#include <kernels/vecadd.cuh>
#include <utils/timer.hpp>

#include <iostream>
#include <cassert>
#include <cstdlib>

using namespace std;

__global__ void vec_add_kernel(int *_a, int *_b, int *_c) {
    int tid = threadIdx.x;
    _c[tid] = _a[tid] + _b[tid];
}

void VecAddKernel::prepare() {
    a = new int[this->size]; memset(a, 0, sizeof(int) * this->size);
    b = new int[this->size]; memset(b, 0, sizeof(int) * this->size);
    c = new int[this->size]; memset(c, 0, sizeof(int) * this->size);
    r = new int[this->size]; memset(r, 0, sizeof(int) * this->size);

    for(int i=0; i<this->size; i++) {
        a[i] = rand() % 10;
        b[i] = rand() % 10;
    }

    double exec_duration = (double) time_execution<chrono::nanoseconds>([&]() {
        for(int i=0; i<this->size; i++) {
            this->c[i] = this->a[i] + this->b[i];
        }
    }).duration.count() / 1e6;

    cout << "[ HOST ] calculation on host took " << exec_duration << " ms\n";

    cout << "[ HOST ] CPU Result: ";
    for(int i=0; i<this->size; i++) cout << this->c[i] << ' ';
    cout << '\n';

    cudaMalloc(&da, sizeof(int) * this->size); cudaMemset(da, 0, sizeof(int) * this->size);
    cudaMalloc(&db, sizeof(int) * this->size); cudaMemset(db, 0, sizeof(int) * this->size);
    cudaMalloc(&dc, sizeof(int) * this->size); cudaMemset(dc, 0, sizeof(int) * this->size);

    cudaMemcpy(da, a, sizeof(int) * this->size, cudaMemcpyHostToDevice);
    cudaMemcpy(db, b, sizeof(int) * this->size, cudaMemcpyHostToDevice);

    cout << "[ HOST ] kernel ready\n";
}

void VecAddKernel::cleanup() {
    cudaMemcpy(r, dc, sizeof(int) * this->size, cudaMemcpyDeviceToHost);

    cout << "[ HOST ] GPU Result: ";
    for(int i=0; i<this->size; i++) cout << this->r[i] << ' ';
    cout << '\n';

    cudaFree(da);
    cudaFree(db);
    cudaFree(dc);

    delete[] a;
    delete[] b;
    delete[] c;
}

void VecAddKernel::launch() {
    assert(this->size <= 1024);

    vec_add_kernel<<<1, this->size>>>(this->da, this->db, this->dc);
}