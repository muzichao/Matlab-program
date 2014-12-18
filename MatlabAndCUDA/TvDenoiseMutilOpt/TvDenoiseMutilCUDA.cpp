#include "mex.h"
#include "TvDenoise.h"

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
    if (nrhs != 4)
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
    int numRowsUz = (int)mxGetM(prhs[1]);//prhs[1]指向第二个变量
    int numColsUz = (int)mxGetN(prhs[1]);
    int numRowsLambda = (int)mxGetM(prhs[2]);//prhs[2]指向第二个变量
    int numColsLambda = (int)mxGetN(prhs[2]);
    int numRowsPiter = (int)mxGetM(prhs[3]);//prhs[2]指向第二个变量
    int numColsPiter = (int)mxGetN(prhs[3]);
    
    // 判断输入参数维度是否满足条件
    if ( numRowsUz != 1 || numColsUz != 1 || numRowsLambda != 1 || numColsLambda != 1 || numRowsPiter != 1 || numColsPiter != 1)
        mexErrMsgTxt("Invalid size.");

    
    //mxGetData 获取数据阵列中的数据
    float *A = (float*)mxGetData(prhs[0]);
    float *band = (float*)mxGetData(prhs[1]);
    float *lambda = (float*)mxGetData(prhs[2]);
    float *piter = (float*)mxGetData(prhs[3]);

    // 生成输出参数的mxArray结构体
    plhs[0] = mxCreateNumericMatrix(numRowsA, numColsA, mxSINGLE_CLASS, mxREAL);
    
    // 获取输出参数的指针
    float* C = (float*)mxGetData(plhs[0]);

    // 传入的numColsA = iCol * band;
    numColsA = numColsA / int(*band);
    
    // 调用子程序
    TvDenoiseGPU(A, C, numRowsA, numColsA, int(*band), *lambda, int(*piter));
}