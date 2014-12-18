#include "mex.h"
#include "TvDenoise.h"

// nlhs: ��������ĸ���(left hand side,��������������)
// plhs�������mxArray�����ͷָ��
// nrhs: �����������(right hand side,��������������)
// prhs�������mxArray�����ͷָ��
//       ��������������������ôprhs[0]ָ���һ������
//       prhs[1]ָ��ڶ�������

// Matlab��arrayʹ��mxArray��������ʾ��
//plhs��hrhs����ָ��mxArray���͵�ָ������
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
    // �ж�������������Ƿ���������
    if (nrhs != 4)
        mexErrMsgTxt("Invaid number of input arguments");
    
    if (nlhs != 1)
        mexErrMsgTxt("Invalid number of outputs");
    // �ж���������������Ƿ���������    
    if (!mxIsSingle(prhs[0]) && !mxIsSingle(prhs[1]))
        mexErrMsgTxt("input vector data type must be single");

    // ��ȡ�������ά��
    // mxGetM:�õ�������������
    // mxGetN:�õ�������������
    int numRowsA = (int)mxGetM(prhs[0]);//��ôprhs[0]ָ���һ������
    int numColsA = (int)mxGetN(prhs[0]);
    int numRowsUz = (int)mxGetM(prhs[1]);//prhs[1]ָ��ڶ�������
    int numColsUz = (int)mxGetN(prhs[1]);
    int numRowsLambda = (int)mxGetM(prhs[2]);//prhs[2]ָ��ڶ�������
    int numColsLambda = (int)mxGetN(prhs[2]);
    int numRowsPiter = (int)mxGetM(prhs[3]);//prhs[2]ָ��ڶ�������
    int numColsPiter = (int)mxGetN(prhs[3]);
    
    // �ж��������ά���Ƿ���������
    if ( numRowsUz != 1 || numColsUz != 1 || numRowsLambda != 1 || numColsLambda != 1 || numRowsPiter != 1 || numColsPiter != 1)
        mexErrMsgTxt("Invalid size.");

    
    //mxGetData ��ȡ���������е�����
    float *A = (float*)mxGetData(prhs[0]);
    float *band = (float*)mxGetData(prhs[1]);
    float *lambda = (float*)mxGetData(prhs[2]);
    float *piter = (float*)mxGetData(prhs[3]);

    // �������������mxArray�ṹ��
    plhs[0] = mxCreateNumericMatrix(numRowsA, numColsA, mxSINGLE_CLASS, mxREAL);
    
    // ��ȡ���������ָ��
    float* C = (float*)mxGetData(plhs[0]);

    // �����numColsA = iCol * band;
    numColsA = numColsA / int(*band);
    
    // �����ӳ���
    TvDenoiseGPU(A, C, numRowsA, numColsA, int(*band), *lambda, int(*piter));
}