#include <stdio.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

__global__ void sin (float *d_a, float *d_b, int n) {
    int idx = threadIdx.x;
    d_b[idx] = sinf(d_a[idx]);
}

int main () {
    float *a, *b;
    int n;
    float *d_a, *d_b;

    printf("Enter size of arrays: ");
    scanf(" %d", &n);

    a = (float*) calloc(n, sizeof(float));
    b = (float*) calloc(n, sizeof(float));

    printf("Enter elements of 1D vector:\n");
    for (int i=0; i<n; i++) {
        scanf(" %f", a + i);
    }

    int size = sizeof(float) * n;

    cudaMalloc((void **) &d_a, size);
    cudaMalloc((void **) &d_b, size);

    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);

    dim3 gridSize(1, 1, 1);
    dim3 blockSize(n, 1, 1);

    sin <<< gridSize, blockSize >>> (d_a, d_b, n);
    cudaMemcpy(b, d_b, size, cudaMemcpyDeviceToHost);

    printf("Result:\n");
    for (int i=0; i<n; i++) {
        printf("%f ", b[i]);
    }

    cudaFree(d_a);
    cudaFree(d_b);
}
