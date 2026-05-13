#include <kernels/kernel.hpp>
#include <kernels/hello.cuh>

#include <iostream>
#include <memory>
#include <vector>
#include <format>

using namespace std;

int main(int argc, char *argv[]) {
    vector<unique_ptr<Kernel>> kernels;

    kernels.push_back(make_unique<HelloKernel>());

    for(auto &kernel : kernels) {
        cout << format("[ HOST ] Launching kernel: {}\n", kernel->get_name());
        
        auto exec_duration = kernel->run();

        cout << format("[ HOST ] Kernel completed in {:.3f} ms\n", exec_duration);
        cout << "\n";
    }

    return 0;
}