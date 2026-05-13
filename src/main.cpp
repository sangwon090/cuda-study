#include <kernels/kernel.hpp>
#include <kernels/hello.cuh>

#include <iostream>
#include <memory>
#include <vector>

using namespace std;

int main(int argc, char *argv[]) {
    vector<unique_ptr<Kernel>> kernels;

    kernels.push_back(make_unique<HelloKernel>());

    for(auto &kernel : kernels) {
        cout << "===== [ " << kernel->get_name() << " ]======\n";
        kernel->run();
    }

    return 0;
}