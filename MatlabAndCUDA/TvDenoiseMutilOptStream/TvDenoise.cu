#include "stdio.h"
#include "TvDenoise.h"
#include "D:\Matlab\extern\include\mex.h"

#define BLOCK_SIZE 16

// c��c++�еľ����������ȴ洢
// M.width ��ƫ��
// M.elements �����׵�ַ
// M(row, col) = *(M.elements + col * M.height + row)
typedef struct
{
    int width; // ����
    int height; // ����
    int band; // �׶���
    int size; // �г�����
    float* elements; // ��ʼָ��
} Matrix;

// ����������к������ɾ���ṹ��
Matrix createMat(const int height, const int width, const int band)
{
    Matrix mat;
    mat.height = height;
    mat.width = width;
    mat.band = band;
    mat.size = height * width;
    return mat;
}

__constant__ float tau = 0.25;

__global__ void TvDenoiseGPUSetZero(Matrix A, float *dhvt, float *dhtp, float *dvtp)
{
    int x_id = blockDim.x * blockIdx.x + threadIdx.x; // ������
    int y_id = blockDim.y * blockIdx.y + threadIdx.y; // ������

    if(x_id < A.width && y_id < A.height)
    {
        int iIdx = x_id * A.height + y_id; // ���̶߳�Ӧ��������λ��
        dhvt[iIdx] = 0;
        dhtp[iIdx] = 0;
        dvtp[iIdx] = 0;
    }
}

__global__ void TvDenoiseGPUStepOne(Matrix A, float *dhvt, float *dhtp, float *dvtp, float lambda)
{
    int x_id = blockDim.x * blockIdx.x + threadIdx.x; // ������
    int y_id = blockDim.y * blockIdx.y + threadIdx.y; // ������

    if(x_id < A.width && y_id < A.height)
    {
        int iIdx = x_id * A.height + y_id; // ���̶߳�Ӧ��������λ��

        // �� dhvt = opQt(pn)
        dhvt[iIdx] = dhtp[((x_id + A.width - 1) % A.width) * A.height + y_id] - dhtp[iIdx]
                     + dvtp[x_id * A.height + (y_id + A.height - 1) % A.height] - dvtp[iIdx];

        // �� dhvt = -opQt(pn) - g ./ lambda
        dhvt[iIdx] = - dhvt[iIdx] - A.elements[iIdx] / lambda;
    }
}

__global__ void TvDenoiseGPUStepTwo(Matrix A, float *dhvt, float *dhtp, float *dvtp, float lambda)
{
    int x_id = blockDim.x * blockIdx.x + threadIdx.x; // ������
    int y_id = blockDim.y * blockIdx.y + threadIdx.y; // ������

    if(x_id < A.width && y_id < A.height)
    {
        int iIdx = x_id * A.height + y_id; // ���̶߳�Ӧ��������λ��

        // �� S = opQ(dhvt) = opQ(-opQt(pn) - g ./ lambda)
        float dh = dhvt[((x_id + 1) % A.width) * A.height + y_id] - dhvt[iIdx];
        float dv = dhvt[x_id * A.height + (y_id + 1) % A.height] - dhvt[iIdx];

        // �� R = (1 + tau * modulo(S))
        float R = 1 + tau * sqrt(dh * dh + dv * dv);

        // �� pn = [dht dvt]
        dhtp[iIdx] = (dhtp[iIdx] + tau * dh) / R;
        dvtp[iIdx] = (dvtp[iIdx] + tau * dv) / R;
    }
}

__global__ void TvDenoiseGPUStepThree(Matrix A, float *dhvt, float *dhtp, float *dvtp, float lambda)
{
    int x_id = blockDim.x * blockIdx.x + threadIdx.x; // ������
    int y_id = blockDim.y * blockIdx.y + threadIdx.y; // ������

    if(x_id < A.width && y_id < A.height)
    {
        int iIdx = x_id * A.height + y_id; // ���̶߳�Ӧ��������λ��

        // �� dhvt = opQt(pn)
        dhvt[iIdx] = dhtp[((x_id + A.width - 1) % A.width) * A.height + y_id] - dhtp[iIdx]
                      + dvtp[x_id * A.height + (y_id + A.height - 1) % A.height] - dvtp[iIdx];
        // ��������д��A������
        A.elements[iIdx] += lambda * dhvt[iIdx];
    }
}

void TvDenoiseGPU(float *A, float *C, int iRow, int iCol, int band, float lambda, int piter)
{
    Matrix d_A = createMat(iRow, iCol, band); // ָ���Դ�ľ���

    size_t oneBandSize = d_A.size * sizeof(float); // һ���׶�ռ���ڴ�ռ��С
    size_t allBandSize = d_A.band * oneBandSize; // �����׶�ռ���ڴ�ռ��С

    // �����м��������ͷָ��
    float *dhvt, *dhtp, *dvtp; // �м����

    // ����Pageable(����ҳ)�ڴ�
    cudaMalloc((void**)&d_A.elements, oneBandSize);// ���Դ���Ϊd_A���ٿռ�
    cudaMalloc((void**)&dhvt, oneBandSize);// ���Դ���Ϊdhvt���ٿռ�
    cudaMalloc((void**)&dhtp, oneBandSize);// ���Դ���Ϊdhtp���ٿռ�
    cudaMalloc((void**)&dvtp, oneBandSize);// ���Դ���Ϊdvtp���ٿռ�

    float *CHost, *AHost;
    // ����Pinned(Page-locked)�ڴ�
    cudaHostAlloc((void**)&CHost, allBandSize, cudaHostAllocDefault);
    cudaHostAlloc((void**)&AHost, allBandSize, cudaHostAllocDefault);

    // ��δ��ҳ���ڴ�A��������ҳ���ڴ�AHost
    memcpy(AHost, A, allBandSize);

    // �˺����߶�
    dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE);
    dim3 dimGrid((d_A.width + BLOCK_SIZE -1) / dimBlock.x,
                 (d_A.height + BLOCK_SIZE -1) / dimBlock.y);

    // ������
    cudaStream_t stream; //���Ľṹ��
    cudaStreamCreate(&stream);

    for(int iBand = 0; iBand < d_A.band; iBand++)
    {
        int iBandOffset = iBand * d_A.size;

        cudaMemcpyAsync(d_A.elements, AHost + iBandOffset, oneBandSize, cudaMemcpyHostToDevice, stream);

        TvDenoiseGPUSetZero<<<dimGrid, dimBlock, 0, stream>>>(d_A, dhvt, dhtp, dvtp); // ��ʼ��htvt, dhtp, dvtp = 0;

        for (int iter = 0; iter < piter; ++iter)
        {
            TvDenoiseGPUStepOne<<<dimGrid, dimBlock, 0, stream>>>(d_A, dhvt, dhtp, dvtp, lambda); // �� dhvt = -opQt(pn) - g ./ lambda
            TvDenoiseGPUStepTwo<<<dimGrid, dimBlock, 0, stream>>>(d_A, dhvt, dhtp, dvtp, lambda);
            cudaStreamSynchronize(stream);
        }
        TvDenoiseGPUStepThree<<<dimGrid, dimBlock, 0, stream>>>(d_A, dhvt, dhtp, dvtp, lambda);

        // ��d_A������Դ��ж��������ڴ���
        cudaMemcpyAsync(CHost + iBandOffset, d_A.elements, oneBandSize, cudaMemcpyDeviceToHost, stream);
    }

    // ǿ��CUDA����ʱ�ȴ��������в������
    cudaStreamSynchronize(stream);

    // ����ҳ���ڴ�CHost������δ��ҳ���ڴ�C
    memcpy(C, CHost, allBandSize);

    // �ͷ�Pinned(Page-locked)�ڴ�
    cudaFreeHost(CHost);
    cudaFreeHost(AHost);

    // �ͷ��Դ�ռ�
    cudaFree(d_A.elements);
    cudaFree(dhvt);
    cudaFree(dhtp);
    cudaFree(dvtp);

    cudaThreadExit();
}
