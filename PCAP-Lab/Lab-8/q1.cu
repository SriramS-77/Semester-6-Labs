#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"


__global__ void matAddRow (int* A, int* B, int* C, int wa) {
    int rowId = threadIdx.x;
    for (int colId=0; colId<wa; colId++) {
        C[rowId * wa + colId] = A[rowId * wa + colId] + B[rowId * wa + colId];
    }
}

__global__ void matAddCol (int* A, int* B, int* C, int ha) {
    int colId = threadIdx.x, wa = blockDim.x;
    for (int rowId=0; rowId<ha; rowId++) {
        C[rowId * wa + colId] = A[rowId * wa + colId] + B[rowId * wa + colId];
    }
}

__global__ void matAddElement (int* A, int* B, int* C) {
    int rowId = threadIdx.x, colId = threadIdx.y, wa = blockDim.y;
    C[rowId * wa + colId] = A[rowId * wa + colId] + B[rowId * wa + colId];
}

__host__ void displayMatrix (int *mat, int h, int w) {
    for (int i=0; i<h; i++) {
        for (int j=0; j<w; j++) {
            printf("%d ", mat[i * w + j]);
        }
        printf("\n");
    }
}

int main () {
    int ha, wa;

    printf("Enter number of rows of matrix A: ");
    scanf(" %d", &ha);
    printf("Enter number of columns of matrix A: ");
    scanf(" %d", &wa);

    int A[ha*wa], B[ha*wa], C[ha*wa], *d_A, *d_B, *d_C;

    printf("Enter %d elements of matrix A:\n", ha*wa);

    for (int i=0; i<ha*wa; i++) {
        scanf(" %d", A+i);
    }

    printf("Enter %d elements of matrix B:\n", ha*wa);

    for (int i=0; i<ha*wa; i++) {
        scanf(" %d", B+i);
    }

    cudaMalloc((void **) &d_A, ha * wa * sizeof(int));
    cudaMalloc((void **) &d_B, ha * wa * sizeof(int));
    cudaMalloc((void **) &d_C, ha * wa * sizeof(int));

    cudaMemcpy(d_A, A, ha * wa * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B, ha * wa * sizeof(int), cudaMemcpyHostToDevice);

    int x = -1;
    while (1) {
        printf("\n1: Row-wise \n2: Column-wise \n3: Element-wise \n0: Exit \nEnter method to use for addition: ");
        scanf(" %d", &x);
        if (x == 0) {
            printf("Exiting...\n");
            break;
        }

        if (x == 1)
            matAddRow <<< 1, ha >>> (d_A, d_B, d_C, wa);
        else if (x == 2)
            matAddCol <<< 1, wa >>> (d_A, d_B, d_C, ha);
        else {
            dim3 blockDim(ha, wa);
            matAddElement <<< 1, blockDim >>> (d_A, d_B, d_C);
        }
            
        cudaMemcpy(C, d_C, ha * wa * sizeof(int), cudaMemcpyDeviceToHost);
    
        printf("\nResultant matrix C:\n");
        displayMatrix(C, ha, wa);
    }

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
}
