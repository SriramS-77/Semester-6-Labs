#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"


__global__ void conv (int* arr, int *mask, int *res, int width, int mask_width) {
    int index = threadIdx.x;
    int total_padding = mask_width - 1;
    int left_padding = total_padding / 2;
    // int right_padding = total_padding - left_padding;
    int sum = 0;

    for (int i=index; i<index+mask_width; i++) {
        if (i < left_padding || i - left_padding >= width) {
            continue;
        }
        sum += arr[i-left_padding] * mask[i-index];
    }
    // printf("%d ---> %d\n", index, sum);
    res[index] = sum;
}

int main () {
    int *arr, *mask, *res;
    int *d_arr, *d_mask, *d_res;
    int width, mask_width;

    printf("Enter length of array: ");
    scanf(" %d", &width);
    arr = (int*) calloc(width, sizeof(int));
    res = (int*) calloc(width, sizeof(int));
    printf("Enter elements of array:\n");
    for (int i=0; i<width; i++) {
        scanf(" %d", arr+i);
    }
    printf("Enter length of mask: ");
    scanf(" %d", &mask_width);
    mask = (int*) calloc(mask_width, sizeof(int));
    printf("Enter elements of mask:\n");
    for (int i=0; i<mask_width; i++) {
        scanf(" %d", mask+i);
    }

    int width_bytes = width * sizeof(int);
    int mask_width_bytes = mask_width * sizeof(int);

    cudaMalloc((void **) &d_arr, width_bytes);
    cudaMalloc((void **) &d_mask, mask_width_bytes);
    cudaMalloc((void **) &d_res, width_bytes);

    cudaMemcpy(d_arr, arr, width_bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(d_mask, mask, mask_width_bytes, cudaMemcpyHostToDevice);

    conv <<< 1, width >>> (d_arr, d_mask, d_res, width, mask_width);

    cudaMemcpy(res, d_res, width_bytes, cudaMemcpyDeviceToHost);

    printf("Resultant array after convolution:\n");
    for (int i=0; i<width; i++) {
        printf("%d ", res[i]);
    }
    printf("\n");

    cudaFree(d_arr);
    cudaFree(d_mask);
    cudaFree(d_res);
}
