#include "TvDenoise.h"
#include "D:\Matlab\extern\include\mex.h"

#define BLOCK_SIZE 32

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

__global__ void TvDenoiseGPUStepOne(Matrix A, float *dhvt, float *dhtp, float *dvtp, float lambda, int piter, int iBand)
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
		dhvt[iIdx] = - dhvt[iIdx] - A.elements[A.size * iBand + iIdx] / lambda;
	}
}

__global__ void TvDenoiseGPUStepTwo(Matrix A, float *dhvt, float *dhtp, float *dvtp, float lambda, int piter)
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

__global__ void TvDenoiseGPUStepThree(Matrix A, float *dhvt, float *dhtp, float *dvtp, float lambda, int piter, int iBand)
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
		A.elements[A.size * iBand + iIdx] += lambda * dhvt[iIdx];
	}
}

void TvDenoiseGPU(float *A, float *C, int iRow, int iCol, int band, float lambda, int piter)
{
    Matrix d_A = createMat(iRow, iCol, band); // ָ���Դ�ľ���

    size_t oneBandSize = d_A.size * sizeof(float); // һ���׶�ռ���ڴ�ռ��С

    cudaMalloc((void**)&d_A.elements, d_A.band * oneBandSize);// ���Դ���Ϊd_A���ٿռ�
    cudaMemcpy(d_A.elements, A, oneBandSize * band, cudaMemcpyHostToDevice);

    float *dhvt; // �м����
    float *dhtp; // �м����
    float *dvtp; // �м����
	cudaMalloc((void**)&dhvt, oneBandSize);// ���Դ���Ϊdhvt���ٿռ�
    cudaMalloc((void**)&dhtp, oneBandSize);// ���Դ���Ϊdhtp���ٿռ�
    cudaMalloc((void**)&dvtp, oneBandSize);// ���Դ���Ϊdvtp���ٿռ�

    // �˺���
    dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE);
    dim3 dimGrid((d_A.width + BLOCK_SIZE -1) / dimBlock.x,
                 (d_A.height + BLOCK_SIZE -1) / dimBlock.y);

    for(int iBand = 0; iBand < band; iBand++)
    {
        cudaMemset(dhvt, 0, oneBandSize); //��ʼ��dhvt
        cudaMemset(dhtp, 0, oneBandSize); //��ʼ��dhtp
        cudaMemset(dvtp, 0, oneBandSize); //��ʼ��dvtp

        for (int iter = 0; iter < piter; ++iter)
        {
            TvDenoiseGPUStepOne<<<dimGrid, dimBlock>>>(d_A, dhvt, dhtp, dvtp, lambda, piter, iBand); // �� dhvt = -opQt(pn) - g ./ lambda
            TvDenoiseGPUStepTwo<<<dimGrid, dimBlock>>>(d_A, dhvt, dhtp, dvtp, lambda, piter);
        }
        TvDenoiseGPUStepThree<<<dimGrid, dimBlock>>>(d_A, dhvt, dhtp, dvtp, lambda, piter, iBand);
    }

    // ��d_A������Դ��ж��������ڴ���
    cudaMemcpy(C, d_A.elements, oneBandSize * band, cudaMemcpyDeviceToHost);

    // �ͷ��Դ�ռ�
    cudaFree(d_A.elements);
	cudaFree(dhvt);
	cudaFree(dhtp);
	cudaFree(dvtp);

    cudaThreadExit();
}
