#include <cuda.h>
#include <math.h>
#include <stdio.h>
#include <assert.h>



void cudaError(cudaError_t err)
    {    
	if (err != cudaSuccess)
	    {
    		fprintf(stderr, "Failed in %s::%d (error code %s)!\n", __FILE__, __LINE__, cudaGetErrorString(err));
    		exit(EXIT_FAILURE);
	    };
    }



__global__ void kernelTest(short *img,  float cre, float cim, float dre, float dim, float pre, float pim )
    {

	int i=blockDim.x*blockIdx.x  +  threadIdx.x;
	assert(i>=0);
	int j=blockDim.y*blockIdx.y  +  threadIdx.y;
	assert(j>=0);
	int ind=i*1024+j; // адрес пикселя в массиве
	assert(ind>=0 && ind<1024*1024);
	// координаты пикселя на комплексной плоскости
	double x=cre +  (((double)i)/1024.0-0.5)*dre;
	double y=cim +  (((double)j)/1024.0-0.5)*dim;
	//img[ind]=(short)(x*x+y*y);
	double re=x;
	double im=y;
	double R=1e2;//0.5+0.5*sqrt(1+4*sqrt(cre*cre+cim*cim));
	int cnt=0;
	do {
	double newre=re*re-im*im+pre;
	double newim=re*im+im*re+pim;
	re=newre;
	im=newim;
	cnt++;
//	} while((x-re)*(x-re)+(y-im)*(y-im)<1e4 && cnt<256);
	} while((re)*(re)+(im)*(im)<R*R && cnt<256*4);
	img[ind]=cnt*256/4;
    };



__host__ int fractal(short *img, float cre, float cim, float dre, float dim, float pre, float pim)
    {

	cudaError_t err;
	int N=1024;
	int size=N*N*sizeof(short);
	int K=16;
	dim3 blockSize = dim3(K,K,1);
	dim3 gridSize  = dim3(N/K,N/K,1);


	short *dA;

//	cudaSetDevice(0);
	cudaError( cudaGetLastError() );
	cudaError( cudaMalloc(&dA, size) );

	kernelTest <<<gridSize, blockSize>>> (dA, cre, cim, dre, dim, pre, pim );
	cudaError(cudaMemcpy(img, dA, size, cudaMemcpyDeviceToHost) );

	cudaFree(dA);
	return 0;
    };    
