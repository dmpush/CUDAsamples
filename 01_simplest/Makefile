ENV+=PATH=$(PATH):/opt/cuda/bin 
ENV+=CUDA_HOME=/opt/cuda

all: envir
	  $(ENV) nvcc lll.cu -ccbin=g++-4.8 -o runme
envir:
	
clean:
	rm -f runme