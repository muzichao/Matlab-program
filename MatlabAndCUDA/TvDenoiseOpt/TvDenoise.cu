#include "TvDenoise.h"
#include "D:\Matlab\extern\include\mex.h"

#define BLOCK_SIZE 16

// c和c++中的矩阵都是行优先存储
// M.width 行偏移
// M.elements 矩阵首地址
// M(row, col) = *(M.elements + col * M.height + row)
typedef struct
			{
				int width;
				int height;
                size_t size;
				float* elements;
			} Matrix;

// 根据输入的行和列生成矩阵结构体
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
    int x_id = blockDim.x * blockIdx.x + threadIdx.x; // 列坐标
    int y_id = blockDim.y * blockIdx.y + threadIdx.y; // 行坐标

	if(x_id < A.width && y_id < A.height)
	{
		int iIdx = x_id * A.height + y_id; // 该线程对应矩阵索引位置

		// 求 dhvt = opQt(pn)
		dhvt[iIdx] = dhtp[((x_id + A.width - 1) % A.width) * A.height + y_id] - dhtp[iIdx]
			         + dvtp[x_id * A.height + (y_id + A.height - 1) % A.height] - dvtp[iIdx];

		// 求 dhvt = -opQt(pn) - g ./ lambda
		dhvt[iIdx] = - dhvt[iIdx] - A.elements[iIdx] / lambda;
	}
}

__global__ void TvDenoiseGPU2(Matrix A, float *dhvt, float *dhtp, float *dvtp, float lambda, int piter, float tau)
{
	int x_id = blockDim.x * blockIdx.x + threadIdx.x; // 列坐标
	int y_id = blockDim.y * blockIdx.y + threadIdx.y; // 行坐标

	if(x_id < A.width && y_id < A.height)
	{
		int iIdx = x_id * A.height + y_id; // 该线程对应矩阵索引位置

		// 求 S = opQ(dhvt) = opQ(-opQt(pn) - g ./ lambda)
		float dh = dhvt[((x_id + 1) % A.width) * A.height + y_id] - dhvt[iIdx];
		float dv = dhvt[x_id * A.height + (y_id + 1) % A.height] - dhvt[iIdx];

		// 求 R = (1 + tau * modulo(S))
		float R = 1 + tau * sqrt(dh * dh + dv * dv);

		// 求 pn = [dht dvt]
		dhtp[iIdx] = (dhtp[iIdx] + tau * dh) / R;
		dvtp[iIdx] = (dvtp[iIdx] + tau * dv) / R;
	}
}

__global__ void TvDenoiseGPU3(Matrix A, float *dhvt, float *dhtp, float *dvtp, float lambda, int piter, float tau)
{
	int x_id = blockDim.x * blockIdx.x + threadIdx.x; // 列坐标
	int y_id = blockDim.y * blockIdx.y + threadIdx.y; // 行坐标

	if(x_id < A.width && y_id < A.height)
	{
		int iIdx = x_id * A.height + y_id; // 该线程对应矩阵索引位置
		// 求 dhvt = opQt(pn)
		dhvt[iIdx] = dhtp[((x_id + A.width - 1) % A.width) * A.height + y_id] - dhtp[iIdx]
		              + dvtp[x_id * A.height + (y_id + A.height - 1) % A.height] - dvtp[iIdx];
		// 将计算结果写入A矩阵中
		A.elements[iIdx] += lambda * dhvt[iIdx];
	}
}

void TvDenoiseGPU(float *A, float *C, int iRow, int iCol, float lambda, int piter, float tau)
{
    Matrix d_A = createMat(iRow, iCol);
    cudaMalloc((void**)&d_A.elements, d_A.size);// 在显存中为d_A开辟空间
    cudaMemcpy(d_A.elements, A, d_A.size, cudaMemcpyHostToDevice);

    float *dhvt; // 中间变量
    float *dhtp; // 中间变量
    float *dvtp; // 中间变量
	cudaMalloc((void**)&dhvt, d_A.size);// 在显存中为dhvt开辟空间
    cudaMalloc((void**)&dhtp, d_A.size);// 在显存中为dhtp开辟空间
    cudaMalloc((void**)&dvtp, d_A.size);// 在显存中为dvtp开辟空间
	cudaMemset(dhvt, 0, d_A.size); //初始化dhvt
	cudaMemset(dhtp, 0, d_A.size); //初始化dhtp
	cudaMemset(dvtp, 0, d_A.size); //初始化dvtp

    // 核函数
    dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE);
    dim3 dimGrid((d_A.width + BLOCK_SIZE -1) / dimBlock.x,
                 (d_A.height + BLOCK_SIZE -1) / dimBlock.y);

	for (int iter = 0; iter < piter; ++iter)
	{
		TvDenoiseGPU1<<<dimGrid, dimBlock>>>(d_A, dhvt, dhtp, dvtp, lambda, piter, tau); // 求 dhvt = -opQt(pn) - g ./ lambda
		TvDenoiseGPU2<<<dimGrid, dimBlock>>>(d_A, dhvt, dhtp, dvtp, lambda, piter, tau);
	}
	TvDenoiseGPU3<<<dimGrid, dimBlock>>>(d_A, dhvt, dhtp, dvtp, lambda, piter, tau);

    // 将d_A矩阵从显存中读到主机内存中
    cudaMemcpy(C, d_A.elements, d_A.size, cudaMemcpyDeviceToHost);

    // 释放显存空间
    cudaFree(d_A.elements);
	cudaFree(dhvt);
	cudaFree(dhtp);
	cudaFree(dvtp);
}
