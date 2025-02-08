#include <stdio.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

__global__ void add (int *d_a, int *d_b, int *d_c, int n) {
    int idx = threadIdx.x;
    d_c[idx] = d_a[idx] + d_b[idx];
}

int main () {
    int *a, *b, *c, n;
    int *d_a, *d_b, *d_c;   

    printf("Enter size of arrays: ");
    scanf(" %d", &n);

    a = (int*) calloc(n, sizeof(int));
    b = (int*) calloc(n, sizeof(int));
    c = (int*) calloc(n, sizeof(int));

    printf("Enter elements of array 1:\n");
    for (int i=0; i<n; i++) {
        scanf(" %d", a + i);
    }
    printf("Enter elements of array 2:\n");
    for (int i=0; i<n; i++) {
        scanf(" %d", b + i);
    }

    int size = sizeof(int) * n;

    cudaMalloc((void **) &d_a, size);
    cudaMalloc((void **) &d_b, size);
    cudaMalloc((void **) &d_c, size);

    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);

    dim3 blockSize(n, 1, 1);

    add <<< 1, blockSize >>> (d_a, d_b, d_c, n);
    cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);

    printf("Result:\n");
    for (int i=0; i<n; i++) {
        printf("%d ", c[i]);
    }

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
}
