#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"


__global__ void odd_even (int* arr, int n) {
    int idx = threadIdx.x;
    int temp, cycles=n/2;

    if (n & 1)
        cycles++;

    for (int i=0; i<cycles; i++) {
        if (idx % 2 == 0 && idx < n-1) {
            if (arr[idx] > arr[idx+1]) {
                temp = arr[idx];
                arr[idx] = arr[idx+1];
                arr[idx+1] = temp;
            }
        }
        else if (idx < n-1) {
            if (arr[idx] > arr[idx+1]) {
                temp = arr[idx];
                arr[idx] = arr[idx+1];
                arr[idx+1] = temp;
            }
        }
        __syncthreads();
    }
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

    odd_even <<< 1, n >>> (d_arr, n);

    cudaMemcpy(arr, d_arr, n_bytes, cudaMemcpyDeviceToHost);

    printf("Resultant array after sorting:\n");
    for (int i=0; i<n; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");

    cudaFree(d_arr);
}
