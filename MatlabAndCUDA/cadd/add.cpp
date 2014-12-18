#include "mex.h"

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
    if (numRowsA != numRowsB || numColsA != numColsB)
        mexErrMsgTxt("Invalid size. The sizes of two vectors must be same");

    int minSize = (numRowsA < numColsA) ? numRowsA : numColsA;
    int maxSize = (numRowsA > numColsA) ? numRowsA : numColsA;

    if (minSize != 1)
        mexErrMsgTxt("Invalid size. The vector must be one dimentional");
    
    //mxGetData 获取数据阵列中的数据
    float* A = (float*)mxGetData(prhs[0]);
    float* B = (float*)mxGetData(prhs[1]);

    // 生成输入参数的mxArray结构体
    plhs[0] = mxCreateNumericMatrix(numRowsA, numColsB, mxSINGLE_CLASS, mxREAL);
    
    // 获取输出参数的指针
    float* C = (float*)mxGetData(plhs[0]);

    // 调用子程序
    C[0] = A[0] + B[0];
}