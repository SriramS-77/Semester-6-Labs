#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"


__device__ int power(int a, int n) {
    int res = 1;
    for (int i=0; i<n; i++)
        res *= a;
    return res;
}

__global__ void changeMat (int* A, int* B) {
    int rowId = threadIdx.x, colId = threadIdx.y;
    int wa = blockDim.y;

    B[rowId*wa+colId] = power(A[rowId*wa+colId], rowId+1);
}


int main () {
    int ha, wa;

    printf("Enter number of rows of matrix A: ");
    scanf(" %d", &ha);
    printf("Enter number of columns of matrix A: ");
    scanf(" %d", &wa);

    int A[ha*wa], B[ha*wa], *d_A, *d_B;

    printf("Enter %d elements of matrix A:\n", ha*wa);

    for (int i=0; i<ha*wa; i++) {
        scanf(" %d", A+i);
    }


    cudaMalloc((void **) &d_A, ha * wa * sizeof(int));
    cudaMalloc((void **) &d_B, ha * wa * sizeof(int));

    cudaMemcpy(d_A, A, ha * wa * sizeof(int), cudaMemcpyHostToDevice);

    dim3 blockDim = dim3(ha, wa);

    changeMat <<< 1, blockDim >>> (d_A, d_B);

    cudaMemcpy(B, d_B, ha * wa * sizeof(int), cudaMemcpyDeviceToHost);

    printf("Resultant vector:\n");
    for (int i=0; i<ha; i++) {
        for (int j=0; j<wa; j++) {
            printf("%d ", B[i*wa+j]);
        }
        printf("\n");
    }

    cudaFree(d_A);
    cudaFree(d_B);
}
