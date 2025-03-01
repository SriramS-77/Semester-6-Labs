#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"


__global__ void change (char* str, char* res, int len_str) {
    int idx = threadIdx.x;
    int startIdx = 0, endIdx;
    for (int i=0; i<idx; i++) 
        startIdx += len_str - i;
    endIdx = startIdx + len_str - idx;
    for (int i=startIdx; i<endIdx; i++) {
        res[i] = str[i - startIdx];
    }
}

int main () {
    char str[20], res[100];
    char *d_str, *d_res;

    printf("Enter the words: ");
    fgets(str, 20, stdin);

    int len_str = strlen(str), len_res=0;
    for (int i=1; i<=len_str; i++)
        len_res += i;
    res[len_res] = '\0';

    printf("%s\n", str);
    printf("Num_str: %d\n", len_str);
    printf("Num_res: %d\n", len_res);

    cudaMalloc((void **) &d_str, len_str * sizeof(char));
    cudaMalloc((void **) &d_res, len_res * sizeof(char));

    cudaMemcpy(d_str, str, len_str * sizeof(char), cudaMemcpyHostToDevice);

    change <<< 1, len_str >>> (d_str, d_res, len_str);

    cudaMemcpy(res, d_res, len_res * sizeof(char), cudaMemcpyDeviceToHost);

    printf("\nResulatant string: %s\n", res);

    cudaFree(d_str);
    cudaFree(d_res);
}
