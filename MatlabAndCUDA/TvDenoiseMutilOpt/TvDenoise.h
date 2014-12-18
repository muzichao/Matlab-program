#ifndef __TVDENOISE__
#define __TVDENOISE__

extern void TvDenoiseGPU(float *A, float *C, int iRow, int iCol, int band, float lambda, int piter);

#endif
