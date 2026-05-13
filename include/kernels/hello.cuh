#pragma once

#include <kernels/kernel.hpp>

class HelloKernel : public Kernel {
public:
    const char* get_name() const override {
        return "Hello Kernel";
    }

    void launch() override;
};
