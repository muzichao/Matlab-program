#include "mex.h"
#include "cuda_runtime.h"
#include "cublas_v2.h"

// nlhs: 输出变量的个数(left hand side,调用语句的左手面)
// plhs：输出的mxArray矩阵的头指针
// nrhs: 输入变量个数(right hand side,调用语句的右手面)
// prhs：输入的mxArray矩阵的头指针
//       如果有两个输入变量，那么prhs[0]指向第一个变量
//       prhs[1]指向第二个变量

// Matlab的array使用mxArray类型来表示。
//plhs和hrhs都是指向mxArray类型的指针数组
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
    // 判断输入参数个数是否满足条件
    if (nrhs != 2)
        mexErrMsgTxt("Invaid number of input arguments");
    
    if (nlhs != 1)
        mexErrMsgTxt("Invalid number of outputs");
    // 判断输入参数的类型是否满足条件    
    if (!mxIsSingle(prhs[0]) && !mxIsSingle(prhs[1]))
        mexErrMsgTxt("input vector data type must be single");

    // 获取输入参数维度
    // mxGetM:得到输入矩阵的行数
    // mxGetN:得到输入矩阵的列数
    int numRowsA = (int)mxGetM(prhs[0]);//那么prhs[0]指向第一个变量
    int numColsA = (int)mxGetN(prhs[0]);
    int numRowsB = (int)mxGetM(prhs[1]);//prhs[1]指向第二个变量
    int numColsB = (int)mxGetN(prhs[1]);
    
    // 判断输入参数维度是否满足条件
    if ( numColsA != numRowsB)
        mexErrMsgTxt("Invalid size. The sizes of two matrixs must be matched");
    
    //mxGetData 获取数据阵列中的数据
    float* A = (float*)mxGetData(prhs[0]);
    float* B = (float*)mxGetData(prhs[1]);
    
    // 获取输出参数的指针
    float* C = (float*)mxGetData(plhs[0]);
    
    int numRowsC = numRowsA;
    int numColsC = numColsB;
 
    // 生成输入参数的mxArray结构体
    plhs[0] = mxCreateNumericMatrix(numRowsC, numColsC, mxSINGLE_CLASS, mxREAL);
    
    // 为矩阵开辟空间
    float *dev_A, *dev_B, *dev_C;
    cudaMalloc(&dev_A, sizeof(float) * numRowsA * numColsA);
    cudaMalloc(&dev_B, sizeof(float) * numRowsB * numColsB);
    cudaMalloc(&dev_C, sizeof(float) * numRowsC * numColsC);
    
    // 调用cublas库函数
    cublasHandle_t handle;
    
    // 对CUBLAS库进行初始化，使用CUBLAS库之前必须有
    cublasCreate(&handle);
    
    // 从主机拷贝矩阵数据到设备
    cublasSetMatrix(numRowsA,
                    numColsA,
                    sizeof(float),
                    A,
                    numRowsA,
                    dev_A,
                    numRowsA);
    // 矩阵乘法
    cublasSetMatrix(numRowsB,
                    numColsB,
                    sizeof(float),
                    B,
                    numRowsB,
                    dev_B,
                    numRowsB);
 
    float alpha = 1.0f;
    float beta = 0.0f;
    cublasSgemm(handle,
                CUBLAS_OP_N,
                CUBLAS_OP_N,
                numRowsA,
                numColsB,
                numColsA,
                &alpha,
                dev_A,
                numRowsA,
                dev_B,
                numRowsB,
                &beta,
                dev_C,
                numRowsC);
    
    // 从设备拷贝矩阵数据到主机
    cublasGetMatrix(numRowsC,
                    numColsC,
                    sizeof(float),
                    dev_C,
                    numRowsC,
                    C,
                    numRowsC);        
    
    // 释放CUBLAS库调用的硬件资源       
    cublasDestroy(handle);   
    
    // 调用子程序
   // mulMatrixs(A, B, C, numRowsA, numColsA, numColsB);
    
    // 释放显存空间
    cudaFree(dev_A);
    cudaFree(dev_B);
    cudaFree(dev_C);
}