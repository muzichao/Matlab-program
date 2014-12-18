#include "mex.h"

// nlhs: 输出变量的个数
// plhs：输出的mxArray矩阵的头指针
// nrhs: 输入变量个数
// prhs：输入的mxArray矩阵的头指针
void mexFunction(int nlhs, mxArray*plhs[], int nrhs, const mxArray*prhs[])
{  
    mexPrintf("Hello, matlab with cuda!\n");
}
