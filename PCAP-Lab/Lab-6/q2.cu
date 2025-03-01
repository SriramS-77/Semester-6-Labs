#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"


__global__ void sort (int* arr, int n) {
    int idx = threadIdx.x;
    int pos = 0, temp;

    for (int i=1; i<idx; i++) {
        if (arr[i] > arr[pos])
            pos = i;
    }
    temp = arr[pos];
    arr[pos] = arr[idx];
    arr[idx] = temp;

    __syncthreads();
}

int main () {
    int *arr;
    int *d_arr;
    int n;

    printf("Enter length of array: ");
    scanf(" %d", &n);
    arr = (int*) calloc(n, sizeof(int));

    printf("Enter elements of array:\n");
    for (int i=0; i<n; i++) {
        scanf(" %d", arr+i);
    }

    int n_bytes = n * sizeof(int);

    cudaMalloc((void **) &d_arr, n_bytes);

    cudaMemcpy(d_arr, arr, n_bytes, cudaMemcpyHostToDevice);

    sort <<< 1, n >>> (d_arr, n);

    cudaMemcpy(arr, d_arr, n_bytes, cudaMemcpyDeviceToHost);

    printf("Resultant array after sorting:\n");
    for (int i=0; i<n; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");

    cudaFree(d_arr);
}
