#include <kernels/hello.cuh>

#include <cstdio>

__global__ void hello_kernel() {
    printf("Hello from GPU: block=%d, thread=%d\n", blockIdx.x, threadIdx.x);
}

void HelloKernel::launch() {
    hello_kernel<<<1, 10>>>();
}