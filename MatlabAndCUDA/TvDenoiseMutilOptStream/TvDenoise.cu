#include "stdio.h"
#include "TvDenoise.h"
#include "D:\Matlab\extern\include\mex.h"

#define BLOCK_SIZE 16

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

__global__ void TvDenoiseGPUSetZero(Matrix A, float *dhvt, float *dhtp, float *dvtp)
{
    int x_id = blockDim.x * blockIdx.x + threadIdx.x; // 列坐标
    int y_id = blockDim.y * blockIdx.y + threadIdx.y; // 行坐标

    if(x_id < A.width && y_id < A.height)
    {
        int iIdx = x_id * A.height + y_id; // 该线程对应矩阵索引位置
        dhvt[iIdx] = 0;
        dhtp[iIdx] = 0;
        dvtp[iIdx] = 0;
    }
}

__global__ void TvDenoiseGPUStepOne(Matrix A, float *dhvt, float *dhtp, float *dvtp, float lambda)
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

__global__ void TvDenoiseGPUStepTwo(Matrix A, float *dhvt, float *dhtp, float *dvtp, float lambda)
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

__global__ void TvDenoiseGPUStepThree(Matrix A, float *dhvt, float *dhtp, float *dvtp, float lambda)
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

void TvDenoiseGPU(float *A, float *C, int iRow, int iCol, int band, float lambda, int piter)
{
    Matrix d_A = createMat(iRow, iCol, band); // 指向显存的矩阵

    size_t oneBandSize = d_A.size * sizeof(float); // 一个谱段占据内存空间大小
    size_t allBandSize = d_A.band * oneBandSize; // 所有谱段占据内存空间大小

    // 定义中间变量数据头指针
    float *dhvt, *dhtp, *dvtp; // 中间变量

    // 分配Pageable(交换页)内存
    cudaMalloc((void**)&d_A.elements, oneBandSize);// 在显存中为d_A开辟空间
    cudaMalloc((void**)&dhvt, oneBandSize);// 在显存中为dhvt开辟空间
    cudaMalloc((void**)&dhtp, oneBandSize);// 在显存中为dhtp开辟空间
    cudaMalloc((void**)&dvtp, oneBandSize);// 在显存中为dvtp开辟空间

    float *CHost, *AHost;
    // 分配Pinned(Page-locked)内存
    cudaHostAlloc((void**)&CHost, allBandSize, cudaHostAllocDefault);
    cudaHostAlloc((void**)&AHost, allBandSize, cudaHostAllocDefault);

    // 把未锁页的内存A拷贝到锁页的内存AHost
    memcpy(AHost, A, allBandSize);

    // 核函数尺度
    dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE);
    dim3 dimGrid((d_A.width + BLOCK_SIZE -1) / dimBlock.x,
                 (d_A.height + BLOCK_SIZE -1) / dimBlock.y);

    // 创建流
    cudaStream_t stream; //流的结构体
    cudaStreamCreate(&stream);

    for(int iBand = 0; iBand < d_A.band; iBand++)
    {
        int iBandOffset = iBand * d_A.size;

        cudaMemcpyAsync(d_A.elements, AHost + iBandOffset, oneBandSize, cudaMemcpyHostToDevice, stream);

        TvDenoiseGPUSetZero<<<dimGrid, dimBlock, 0, stream>>>(d_A, dhvt, dhtp, dvtp); // 初始化htvt, dhtp, dvtp = 0;

        for (int iter = 0; iter < piter; ++iter)
        {
            TvDenoiseGPUStepOne<<<dimGrid, dimBlock, 0, stream>>>(d_A, dhvt, dhtp, dvtp, lambda); // 求 dhvt = -opQt(pn) - g ./ lambda
            TvDenoiseGPUStepTwo<<<dimGrid, dimBlock, 0, stream>>>(d_A, dhvt, dhtp, dvtp, lambda);
            cudaStreamSynchronize(stream);
        }
        TvDenoiseGPUStepThree<<<dimGrid, dimBlock, 0, stream>>>(d_A, dhvt, dhtp, dvtp, lambda);

        // 将d_A矩阵从显存中读到主机内存中
        cudaMemcpyAsync(CHost + iBandOffset, d_A.elements, oneBandSize, cudaMemcpyDeviceToHost, stream);
    }

    // 强制CUDA运行时等待流中所有操作完成
    cudaStreamSynchronize(stream);

    // 把锁页的内存CHost拷贝到未锁页的内存C
    memcpy(C, CHost, allBandSize);

    // 释放Pinned(Page-locked)内存
    cudaFreeHost(CHost);
    cudaFreeHost(AHost);

    // 释放显存空间
    cudaFree(d_A.elements);
    cudaFree(dhvt);
    cudaFree(dhtp);
    cudaFree(dvtp);

    cudaThreadExit();
}
