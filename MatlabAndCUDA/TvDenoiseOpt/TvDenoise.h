#ifndef __TVDENOISE__
#define __TVDENOISE__

extern void TvDenoiseGPU(float *A, float *C, int iRow, int iCol, float lambda, int piter, float tau);

#endif
