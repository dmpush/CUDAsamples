#include <cuda.h>
#include <math.h>
#include <stdio.h>
#include <assert.h>

#define TYPE float


void cudaError(cudaError_t err)
    {    
	if (err != cudaSuccess)
	    {
    		fprintf(stderr, "Failed in %s::%d (error code %s)!\n", __FILE__, __LINE__, cudaGetErrorString(err));
    		exit(EXIT_FAILURE);
	    };
    }



__global__ void kernelTest(TYPE *A)
    {
	int i=blockDim.y*threadIdx.x   +  threadIdx.y;
//	for(int k=0; k<1024*1024*1024; k++)
	    A[i] = i+1;
//	assert(0);
    };

__host__ int main(int argc, char *argv[])
    {
	cudaError_t err;
	int N=10;
	int size=N*N*sizeof(TYPE);

	dim3 blockSize = dim3(N,N,1);
	dim3 gridSize  = dim3(1,1,1);

	TYPE *hA;
	hA=(TYPE*)malloc(size);

	for(int n=0; n<N*N; n++)
	    hA[n]=n;

	TYPE *dA;

	cudaSetDevice(0);
	cudaError( cudaGetLastError() );
	cudaError( cudaMalloc(&dA, size) );

//	cudaError(cudaMemcpy(dA, hA, size, cudaMemcpyHostToDevice) );

	kernelTest <<<gridSize, blockSize>>> (dA);

/*
	cudaEvent_t syncEvent;
	cudaError( cudaEventCreate(&syncEvent) );
	cudaError( cudaEventRecord(syncEvent, 0) );
	cudaError( cudaEventSynchronize(syncEvent) );
*/
//	cudaError( cudaDeviceSynchronize()  );


	cudaError(cudaMemcpy(hA, dA, size, cudaMemcpyDeviceToHost) );

	for(int i=0; i<10; i++)
	    printf("Result: %d %f\n", i, (float)hA[i]);
	printf("Ok!\n");
	cudaFree(dA);
	free(hA);
	
	return 0;
    };    
