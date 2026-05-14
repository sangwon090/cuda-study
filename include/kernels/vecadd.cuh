#pragma once

#include <kernels/kernel.hpp>
#define DEFAULT_SIZE 1024

class VecAddKernel : public Kernel {
private:
    int size = DEFAULT_SIZE;
    int *a, *b, *c, *r;
    int *da, *db, *dc;

public:
    VecAddKernel() : size(DEFAULT_SIZE) { }
    VecAddKernel(int size) : size(size) { }

    const char* get_name() const override {
        return "Vector Addition Kernel";
    }

    void prepare() override;
    void cleanup() override;
    void launch() override;
};