ENV+=PATH=$(PATH):/opt/cuda/bin 
ENV+=CUDA_HOME=/opt/cuda

all: 
	$(ENV) nvcc  -arch=sm_20 -ccbin=g++-4.8 -Xcompiler '-fPIC' -dc cuda.cu
	$(ENV) nvcc  -arch=sm_20 -ccbin=g++-4.8 -Xcompiler '-fPIC' -dlink cuda.o -o libs.o  -L/opt/cuda/lib64 -lcudart
	g++-4.8 -shared cuda.o  -o libmycuda.so libs.o 
	g++-4.8  sdl.cpp -lSDL -L. -lmycuda -L/opt/cuda/lib64 -lcudart -o runme
	
clean:
	rm -f runme
	rm -f libmycuda.so
	rm -f *.o
run:
	LD_LIBRARY_PATH=.:/opt/cuda/lib64 ./runme