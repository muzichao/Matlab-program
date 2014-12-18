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
    if (nrhs != 1)
        mexErrMsgTxt("Invaid number of input arguments");


    // ��ȡ�������ά��
    // mxGetM:�õ�������������
    // mxGetN:�õ�������������
    int numRowsA = (int)mxGetM(prhs[0]);//��ôprhs[0]ָ���һ������
    int numColsA = (int)mxGetN(prhs[0]);
    int numRowsBand = (int)mxGetM(prhs[1]);//prhs[1]ָ��ڶ�������
    int numColsBand = (int)mxGetN(prhs[1]);

        // �ж��������ά���Ƿ���������
    if ( numRowsBand != 1 || numColsBand != 1)
        mexErrMsgTxt("Invalid size.");

    //mxGetData ��ȡ���������е�����
    float *A = (float*)mxGetData(prhs[0]);
    float *band = (float*)mxGetData(prhs[1]);

    // �����numColsA = iCol * band;
    numColsA = numColsA / int(*band);

    // �������������mxArray�ṹ��
    plhs[0] = mxCreateNumericMatrix(numRowsA, numColsA, mxSINGLE_CLASS, mxREAL);

    // ��ȡ���������ָ��
    float* C = (float*)mxGetData(plhs[0]);

    // �����ӳ���
    TvDenoiseGPU(A, C, numRowsA, numColsA, int(*band));
}
