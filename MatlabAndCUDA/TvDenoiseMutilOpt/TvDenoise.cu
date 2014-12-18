#include "TvDenoise.h"
#include "D:\Matlab\extern\include\mex.h"

#define BLOCK_SIZE 32

// c和c++中的矩阵都是行优先存储
// M.width 行偏移
// M.elements 矩阵首地址
// M(row, col) = *(M.elements + col * M.height + row)
typedef struct
{
	int width; // 列数
	int height; // 行数
    int band; // 谱段数
	int size; // 行乘以列
	float* elements; // 起始指针
} Matrix;

// 根据输入的行和列生成矩阵结构体
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
    int x_id = blockDim.x * blockIdx.x + threadIdx.x; // 列坐标
    int y_id = blockDim.y * blockIdx.y + threadIdx.y; // 行坐标

	if(x_id < A.width && y_id < A.height)
	{
		int iIdx = x_id * A.height + y_id; // 该线程对应矩阵索引位置

		// 求 dhvt = opQt(pn)
        dhvt[iIdx] = dhtp[((x_id + A.width - 1) % A.width) * A.height + y_id] - dhtp[iIdx]
                     + dvtp[x_id * A.height + (y_id + A.height - 1) % A.height] - dvtp[iIdx];

		// 求 dhvt = -opQt(pn) - g ./ lambda
		dhvt[iIdx] = - dhvt[iIdx] - A.elements[A.size * iBand + iIdx] / lambda;
	}
}

__global__ void TvDenoiseGPUStepTwo(Matrix A, float *dhvt, float *dhtp, float *dvtp, float lambda, int piter)
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

__global__ void TvDenoiseGPUStepThree(Matrix A, float *dhvt, float *dhtp, float *dvtp, float lambda, int piter, int iBand)
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
		A.elements[A.size * iBand + iIdx] += lambda * dhvt[iIdx];
	}
}

void TvDenoiseGPU(float *A, float *C, int iRow, int iCol, int band, float lambda, int piter)
{
    Matrix d_A = createMat(iRow, iCol, band); // 指向显存的矩阵

    size_t oneBandSize = d_A.size * sizeof(float); // 一个谱段占据内存空间大小

    cudaMalloc((void**)&d_A.elements, d_A.band * oneBandSize);// 在显存中为d_A开辟空间
    cudaMemcpy(d_A.elements, A, oneBandSize * band, cudaMemcpyHostToDevice);

    float *dhvt; // 中间变量
    float *dhtp; // 中间变量
    float *dvtp; // 中间变量
	cudaMalloc((void**)&dhvt, oneBandSize);// 在显存中为dhvt开辟空间
    cudaMalloc((void**)&dhtp, oneBandSize);// 在显存中为dhtp开辟空间
    cudaMalloc((void**)&dvtp, oneBandSize);// 在显存中为dvtp开辟空间

    // 核函数
    dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE);
    dim3 dimGrid((d_A.width + BLOCK_SIZE -1) / dimBlock.x,
                 (d_A.height + BLOCK_SIZE -1) / dimBlock.y);

    for(int iBand = 0; iBand < band; iBand++)
    {
        cudaMemset(dhvt, 0, oneBandSize); //初始化dhvt
        cudaMemset(dhtp, 0, oneBandSize); //初始化dhtp
        cudaMemset(dvtp, 0, oneBandSize); //初始化dvtp

        for (int iter = 0; iter < piter; ++iter)
        {
            TvDenoiseGPUStepOne<<<dimGrid, dimBlock>>>(d_A, dhvt, dhtp, dvtp, lambda, piter, iBand); // 求 dhvt = -opQt(pn) - g ./ lambda
            TvDenoiseGPUStepTwo<<<dimGrid, dimBlock>>>(d_A, dhvt, dhtp, dvtp, lambda, piter);
        }
        TvDenoiseGPUStepThree<<<dimGrid, dimBlock>>>(d_A, dhvt, dhtp, dvtp, lambda, piter, iBand);
    }

    // 将d_A矩阵从显存中读到主机内存中
    cudaMemcpy(C, d_A.elements, oneBandSize * band, cudaMemcpyDeviceToHost);

    // 释放显存空间
    cudaFree(d_A.elements);
	cudaFree(dhvt);
	cudaFree(dhtp);
	cudaFree(dvtp);

    cudaThreadExit();
}
