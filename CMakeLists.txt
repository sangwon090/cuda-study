cmake_minimum_required(VERSION 3.23)

project(cuda_study
    VERSION 0.1.0
    LANGUAGES CXX CUDA
)

find_package(CUDAToolkit REQUIRED)

add_executable(cuda_study
    src/main.cpp
    src/kernels/hello.cu
)

target_compile_features(cuda_study PRIVATE cxx_std_23 cuda_std_17)

target_include_directories(cuda_study
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(cuda_study
    PRIVATE
        CUDA::cudart
)

set_target_properties(cuda_study PROPERTIES
    CUDA_SEPARABLE_COMPILATION ON
    CUDA_ARCHITECTURES 89-real
)