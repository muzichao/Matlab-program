#include "mulMatrixs.h"
#include "D:\Matlab\extern\include\mex.h"

#define BLOCK_SIZE 32

// c��c++�еľ����������ȴ洢
// M.stride ��ƫ��
// �˴�����ƫ����Ϊ�˷���ȡ������ӿ�
// M.elements �����׵�ַ
// M(row, col) = *(M.elements + col * M.stride + row)
typedef struct 
			{
				int width;
				int height;
				int stride;
				size_t size;
				float* elements;
			} Matrix;

// ����������к������ɾ���ṹ��
Matrix createMat(const int height, const int width)
{
	Matrix mat;
	mat.height = height;
	mat.width = width;
	mat.stride = height;
	mat.size = height * width * sizeof(float);
	return mat;
}

// ��þ���mat��(row, col)����Ԫ��
// �����ж���Ϊ�˷�ֹԽ��
// ���磺�����С�����߳̿�������ʱ�����ٵ��߳��Ǵ��ھ���Ԫ������
__device__ float GetElement(const Matrix mat, int row, int col)
{
	if(row < mat.height && col < mat.width)
		return mat.elements[col * mat.stride + row];
	else
		return 0;
}

// ���þ���mat��(row, col)����Ԫ��
// �����ж���Ϊ�˷�ֹԽ��
// ���磺�����С�����߳̿�������ʱ�����ٵ��߳��Ǵ��ھ���Ԫ������
__device__ void SetElement(Matrix mat, int row, int col, float value)
{
	if(row < mat.height && col < mat.width)
		mat.elements[col * mat.stride + row] = value;
}

// ���mat��һ���Ӿ���matSub����СΪ��BLOCK_SIZE * BLOCK_SIZE 
// �Ӿ���������Ϊ��row�� col��
__device__ Matrix GetSubMatrix(Matrix mat, int row, int col)
{
	Matrix matSub;
	matSub.width = BLOCK_SIZE;
	matSub.height = BLOCK_SIZE;
	matSub.stride = mat.stride; // �Ӿ�����ԭ�������ƫ����ͬ
	matSub.elements = &mat.elements[mat.stride * BLOCK_SIZE * col + BLOCK_SIZE * row];
	return matSub;
}

// ������˵ĺ˺���
__global__ void MatMulKernel(Matrix A, Matrix B, Matrix C)
{
	// ���Ӧ���к���
	int blockRow = blockIdx.y;
	int blockCol = blockIdx.x;

	// ÿһ���̼߳���C�е�һ��Ԫ��
	// ���������Cvalue
	float Cvalue = 0;

	// �ӿ����̵߳�����
	int row = threadIdx.y;
	int col = threadIdx.x;

	// A�����ӿ� * B�����ӿ� = ��ӦC���ӿ�Csub
	// һ��ѭ���� A�����ӿ��е�һ���ӿ� * B�����ӿ��е�һ���ӿ� ����ӣ�
	// �ӿ��ѭ��
	for (int m = 0; m <  ((A.width + BLOCK_SIZE -1) / BLOCK_SIZE); ++m) 
	{
		// �õ�A�е�һ���ӿ�Asub
		Matrix Asub = GetSubMatrix(A, blockRow, m);

		// �õ�B�е�һ���ӿ�Bsub
		Matrix Bsub = GetSubMatrix(B, m, blockCol);

		// ���乲���ڴ�ռ䣬�������Asub��Bsub
		__shared__ float As[BLOCK_SIZE][BLOCK_SIZE];
		__shared__ float Bs[BLOCK_SIZE][BLOCK_SIZE];

		// ��Asub��Bsub�����������ڴ���
		// ÿһ���߳̿����ӿ��е�һ��Ԫ��
		// ��Ϊ���һ���ӿ�����һ���ӿ����δ��
		// ��˽����жϣ���ֹԽ��
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

		// ���߳̿��е��߳̽���ͬ����ȷ���߳̿��е�ÿ���̶߳�ִ����
		// �˴�ͬ����Ϊ��ȷ���Ӿ����Ѿ������������ڴ���
		__syncthreads();

		// A�ӿ����*B�ӿ����
		// �ӿ��ڵ�ѭ��
		for (int e = 0; e < BLOCK_SIZE; ++e)
		{
			Cvalue += As[row][e] * Bs[e][col];
		}

		// ͬ��,ȷ����ǰA�ӿ���B�ӿ�ļ������
		// ͬ����ɲŽ��¸�A�ӿ���B�ӿ鿽���Ĺ����ڴ�
		__syncthreads();
	}

	// C�ӿ�Csub�ļ��������
	// ÿ���߳�дһ��Ԫ��
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
