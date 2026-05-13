#pragma once

#include <cuda_runtime.h>
#include <stdexcept>
#include <string>

class Kernel {
public:
    virtual ~Kernel() = default;

    virtual const char* get_name() const = 0;

    virtual void launch() = 0;
    virtual void run() {
        cudaError_t err;
        launch();

        err = cudaGetLastError();
        if(err != cudaSuccess) {
            throw std::runtime_error(cudaGetErrorString(err));
        }

        err = cudaDeviceSynchronize();
        if(err != cudaSuccess) {
            throw std::runtime_error(cudaGetErrorString(err));
        }
    }
};