#include "AddMatrixs.h"
#include "D:\Matlab\extern\include\mex.h"

#define BLOCK_SIZE 32
__global__ void addMatrixsMask(float* A, float* B, float* C, int Row, int Col)
{
    int i = threadIdx.x + blockIdx.x * blockDim.x;
    int j = threadIdx.y + blockIdx.y * blockDim.y;
    
    if(i >= Row || j >= Col)
        return;

    //C[i][j] = A[i][j] + B[i][j];
    C[j * Row + i] = A[j * Row + i] + B[j * Row + i];
}

void addMatrixs(float* A, float* B, float* C, int Row, int Col)
{
    float *devPtrA = 0, *devPtrB = 0, *devPtrC = 0;
    
    cudaMalloc(&devPtrA, sizeof(float) * Row * Col);
    cudaMalloc(&devPtrB, sizeof(float) * Row * Col);
    cudaMalloc(&devPtrC, sizeof(float) * Row * Col);
    
    cudaMemcpy(devPtrA, A, sizeof(float) * Row * Col, cudaMemcpyHostToDevice);
    cudaMemcpy(devPtrB, B, sizeof(float) * Row * Col, cudaMemcpyHostToDevice);
    
    dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE);
    dim3 dimGrid(int((Col + BLOCK_SIZE -1 )/BLOCK_SIZE),
                 int((Row + BLOCK_SIZE -1 )/BLOCK_SIZE));
    addMatrixsMask<<<dimGrid, dimBlock>>>(devPtrA, devPtrB, devPtrC, Row, Col);
    
    cudaMemcpy(C, devPtrC, sizeof(float) * Row * Col, cudaMemcpyDeviceToHost);
    
    cudaFree(devPtrA);
    cudaFree(devPtrB);
    cudaFree(devPtrC);   
}
