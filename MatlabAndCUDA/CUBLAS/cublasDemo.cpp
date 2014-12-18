#include "mex.h"
#include "cuda_runtime.h"
#include "cublas_v2.h"

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
    
    // ��ȡ���������ָ��
    float* C = (float*)mxGetData(plhs[0]);
    
    int numRowsC = numRowsA;
    int numColsC = numColsB;
 
    // �������������mxArray�ṹ��
    plhs[0] = mxCreateNumericMatrix(numRowsC, numColsC, mxSINGLE_CLASS, mxREAL);
    
    // Ϊ���󿪱ٿռ�
    float *dev_A, *dev_B, *dev_C;
    cudaMalloc(&dev_A, sizeof(float) * numRowsA * numColsA);
    cudaMalloc(&dev_B, sizeof(float) * numRowsB * numColsB);
    cudaMalloc(&dev_C, sizeof(float) * numRowsC * numColsC);
    
    // ����cublas�⺯��
    cublasHandle_t handle;
    
    // ��CUBLAS����г�ʼ����ʹ��CUBLAS��֮ǰ������
    cublasCreate(&handle);
    
    // �����������������ݵ��豸
    cublasSetMatrix(numRowsA,
                    numColsA,
                    sizeof(float),
                    A,
                    numRowsA,
                    dev_A,
                    numRowsA);
    // ����˷�
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
    
    // ���豸�����������ݵ�����
    cublasGetMatrix(numRowsC,
                    numColsC,
                    sizeof(float),
                    dev_C,
                    numRowsC,
                    C,
                    numRowsC);        
    
    // �ͷ�CUBLAS����õ�Ӳ����Դ       
    cublasDestroy(handle);   
    
    // �����ӳ���
   // mulMatrixs(A, B, C, numRowsA, numColsA, numColsB);
    
    // �ͷ��Դ�ռ�
    cudaFree(dev_A);
    cudaFree(dev_B);
    cudaFree(dev_C);
}