#include "TvDenoise.h"
#include "D:\Matlab\extern\include\mex.h"

#define BLOCK_SIZE 16

// c��c++�еľ����������ȴ洢
// M.width ��ƫ��
// M.elements �����׵�ַ
// M(row, col) = *(M.elements + col * M.height + row)
typedef struct
			{
				int width;
				int height;
                size_t size;
				float* elements;
			} Matrix;

// ����������к������ɾ���ṹ��
Matrix createMat(const int height, const int width)
{
	Matrix mat;
	mat.height = height;
	mat.width = width;
	mat.size = height * width * sizeof(float);
	return mat;
}

__global__ void TvDenoiseGPU1(Matrix A, float *dhvt, float *dhtp, float *dvtp, float lambda, int piter, float tau)
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

__global__ void TvDenoiseGPU2(Matrix A, float *dhvt, float *dhtp, float *dvtp, float lambda, int piter, float tau)
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

__global__ void TvDenoiseGPU3(Matrix A, float *dhvt, float *dhtp, float *dvtp, float lambda, int piter, float tau)
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

void TvDenoiseGPU(float *A, float *C, int iRow, int iCol, float lambda, int piter, float tau)
{
    Matrix d_A = createMat(iRow, iCol);
    cudaMalloc((void**)&d_A.elements, d_A.size);// ���Դ���Ϊd_A���ٿռ�
    cudaMemcpy(d_A.elements, A, d_A.size, cudaMemcpyHostToDevice);

    float *dhvt; // �м����
    float *dhtp; // �м����
    float *dvtp; // �м����
	cudaMalloc((void**)&dhvt, d_A.size);// ���Դ���Ϊdhvt���ٿռ�
    cudaMalloc((void**)&dhtp, d_A.size);// ���Դ���Ϊdhtp���ٿռ�
    cudaMalloc((void**)&dvtp, d_A.size);// ���Դ���Ϊdvtp���ٿռ�
	cudaMemset(dhvt, 0, d_A.size); //��ʼ��dhvt
	cudaMemset(dhtp, 0, d_A.size); //��ʼ��dhtp
	cudaMemset(dvtp, 0, d_A.size); //��ʼ��dvtp

    // �˺���
    dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE);
    dim3 dimGrid((d_A.width + BLOCK_SIZE -1) / dimBlock.x,
                 (d_A.height + BLOCK_SIZE -1) / dimBlock.y);

	for (int iter = 0; iter < piter; ++iter)
	{
		TvDenoiseGPU1<<<dimGrid, dimBlock>>>(d_A, dhvt, dhtp, dvtp, lambda, piter, tau); // �� dhvt = -opQt(pn) - g ./ lambda
		TvDenoiseGPU2<<<dimGrid, dimBlock>>>(d_A, dhvt, dhtp, dvtp, lambda, piter, tau);
	}
	TvDenoiseGPU3<<<dimGrid, dimBlock>>>(d_A, dhvt, dhtp, dvtp, lambda, piter, tau);

    // ��d_A������Դ��ж��������ڴ���
    cudaMemcpy(C, d_A.elements, d_A.size, cudaMemcpyDeviceToHost);

    // �ͷ��Դ�ռ�
    cudaFree(d_A.elements);
	cudaFree(dhvt);
	cudaFree(dhtp);
	cudaFree(dvtp);
}
