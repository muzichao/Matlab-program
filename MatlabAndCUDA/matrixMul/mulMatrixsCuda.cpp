#include "mex.h"
#include "mulMatrixs.h"

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
    if (nrhs != 2)
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
    int numRowsB = (int)mxGetM(prhs[1]);//prhs[1]ָ��ڶ�������
    int numColsB = (int)mxGetN(prhs[1]);
    
    // �ж��������ά���Ƿ���������
    if ( numColsA != numRowsB)
        mexErrMsgTxt("Invalid size. The sizes of two matrixs must be matched");

    
    //mxGetData ��ȡ���������е�����
    float* A = (float*)mxGetData(prhs[0]);
    float* B = (float*)mxGetData(prhs[1]);

    // �������������mxArray�ṹ��
    plhs[0] = mxCreateNumericMatrix(numRowsA, numColsB, mxSINGLE_CLASS, mxREAL);
    
    // ��ȡ���������ָ��
    float* C = (float*)mxGetData(plhs[0]);

    // �����ӳ���
    mulMatrixs(A, B, C, numRowsA, numColsA, numColsB);
}