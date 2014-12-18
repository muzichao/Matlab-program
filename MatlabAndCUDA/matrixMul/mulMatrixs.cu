#include "mulMatrixs.h"
#include "D:\Matlab\extern\include\mex.h"

#define BLOCK_SIZE 32

// c和c++中的矩阵都是行优先存储
// M.stride 行偏移
// 此处的行偏移是为了方便取矩阵的子块
// M.elements 矩阵首地址
// M(row, col) = *(M.elements + col * M.stride + row)
typedef struct 
			{
				int width;
				int height;
				int stride;
				size_t size;
				float* elements;
			} Matrix;

// 根据输入的行和列生成矩阵结构体
Matrix createMat(const int height, const int width)
{
	Matrix mat;
	mat.height = height;
	mat.width = width;
	mat.stride = height;
	mat.size = height * width * sizeof(float);
	return mat;
}

// 获得矩阵mat中(row, col)处的元素
// 进行判断是为了防止越界
// 比如：矩阵大小不是线程块整数倍时，开辟的线程是大于矩阵元素数的
__device__ float GetElement(const Matrix mat, int row, int col)
{
	if(row < mat.height && col < mat.width)
		return mat.elements[col * mat.stride + row];
	else
		return 0;
}

// 设置矩阵mat中(row, col)处的元素
// 进行判断是为了防止越界
// 比如：矩阵大小不是线程块整数倍时，开辟的线程是大于矩阵元素数的
__device__ void SetElement(Matrix mat, int row, int col, float value)
{
	if(row < mat.height && col < mat.width)
		mat.elements[col * mat.stride + row] = value;
}

// 获得mat的一个子矩阵matSub，大小为：BLOCK_SIZE * BLOCK_SIZE 
// 子矩阵块的坐标为（row， col）
__device__ Matrix GetSubMatrix(Matrix mat, int row, int col)
{
	Matrix matSub;
	matSub.width = BLOCK_SIZE;
	matSub.height = BLOCK_SIZE;
	matSub.stride = mat.stride; // 子矩阵与原矩阵的列偏移相同
	matSub.elements = &mat.elements[mat.stride * BLOCK_SIZE * col + BLOCK_SIZE * row];
	return matSub;
}

// 矩阵相乘的核函数
__global__ void MatMulKernel(Matrix A, Matrix B, Matrix C)
{
	// 块对应的行和列
	int blockRow = blockIdx.y;
	int blockCol = blockIdx.x;

	// 每一个线程计算C中的一个元素
	// 将结果存在Cvalue
	float Cvalue = 0;

	// 子块内线程的坐标
	int row = threadIdx.y;
	int col = threadIdx.x;

	// A的行子块 * B的列子块 = 对应C的子块Csub
	// 一个循环： A的行子块中的一个子块 * B的列子块中的一个子块 （相加）
	// 子块的循环
	for (int m = 0; m <  ((A.width + BLOCK_SIZE -1) / BLOCK_SIZE); ++m) 
	{
		// 得到A中的一个子块Asub
		Matrix Asub = GetSubMatrix(A, blockRow, m);

		// 得到B中的一个子块Bsub
		Matrix Bsub = GetSubMatrix(B, m, blockCol);

		// 分配共享内存空间，用来存放Asub和Bsub
		__shared__ float As[BLOCK_SIZE][BLOCK_SIZE];
		__shared__ float Bs[BLOCK_SIZE][BLOCK_SIZE];

		// 将Asub和Bsub拷贝到共享内存中
		// 每一个线程拷贝子块中的一个元素
		// 因为最后一行子块或最后一列子块可能未满
		// 因此进行判断，防止越界
		if((m * BLOCK_SIZE + col < A.width) &&
			(blockRow * BLOCK_SIZE + row < A.height))
		{
			As[row][col] = GetElement(Asub, row, col);
		}
		else
		{
			As[row][col] = 0;
		}

		if((blockCol * BLOCK_SIZE + col < B.width) &&
			(m * BLOCK_SIZE + row < B.height))
		{
			Bs[row][col] = GetElement(Bsub, row, col);
		}
		else
		{
			Bs[row][col] = 0;
		}

		// 对线程块中的线程进行同步，确保线程块中的每个线程都执行完
		// 此处同步是为了确保子矩阵都已经拷贝到共享内存中
		__syncthreads();

		// A子块的行*B子块的列
		// 子块内的循环
		for (int e = 0; e < BLOCK_SIZE; ++e)
		{
			Cvalue += As[row][e] * Bs[e][col];
		}

		// 同步,确保当前A子块与B子块的计算完成
		// 同步完成才将下个A子块与B子块拷贝的共享内存
		__syncthreads();
	}

	// C子块Csub的计算已完成
	// 每个线程写一个元素
	//SetElement(Csub, row, col, Cvalue);
	SetElement(C, blockRow * blockDim.y + row, blockCol * blockDim.x + col, Cvalue);
}

void mulMatrixs(float* A, float* B, float* C, int numRowsA, int numColsA, int numColsB)
{
    Matrix dev_A, dev_B, dev_C;
    dev_A = createMat(numRowsA, numColsA);
    dev_B = createMat(numColsA, numColsB);
    dev_C = createMat(numRowsA, numColsB);

    cudaMalloc(&dev_A.elements, dev_A.size);
    cudaMalloc(&dev_B.elements, dev_B.size);
    cudaMalloc(&dev_C.elements, dev_C.size);
    
    cudaMemcpy(dev_A.elements, A, dev_A.size, cudaMemcpyHostToDevice);
    cudaMemcpy(dev_B.elements, B, dev_B.size, cudaMemcpyHostToDevice);
    
    dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE);
    dim3 dimGrid(int((numColsB + BLOCK_SIZE -1 )/BLOCK_SIZE),
                 int((numRowsA + BLOCK_SIZE -1 )/BLOCK_SIZE));
    MatMulKernel<<<dimGrid, dimBlock>>>(dev_A, dev_B, dev_C);
    
    cudaMemcpy(C, dev_C.elements, dev_C.size, cudaMemcpyDeviceToHost);
    
    cudaFree(dev_A.elements);
    cudaFree(dev_B.elements);
    cudaFree(dev_C.elements);   
}
