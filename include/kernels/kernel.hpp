#pragma once

#include <cuda_runtime.h>
#include <stdexcept>
#include <string>

class Kernel {
public:
    virtual ~Kernel() = default;

    virtual const char* get_name() const = 0;

    virtual void launch() = 0;
    virtual float run() {
        cudaError_t err;
        cudaEvent_t start, stop;

        cudaEventCreate(&start);
        cudaEventCreate(&stop);
        cudaEventRecord(start);

        launch();

        err = cudaGetLastError();
        if(err != cudaSuccess) {
            throw std::runtime_error(cudaGetErrorString(err));
        }

        cudaEventRecord(stop);
        err = cudaDeviceSynchronize();
        if(err != cudaSuccess) {
            throw std::runtime_error(cudaGetErrorString(err));
        }

        float elapsed = 0.0f;
        cudaEventElapsedTime(&elapsed, start, stop);
        cudaEventDestroy(start);
        cudaEventDestroy(stop);

        return elapsed;
    }
};