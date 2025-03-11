#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"


__global__ void matMulRow (int* A, int* B, int* C, int wa, int wb) {
    int rowId = threadIdx.x, val;
    for (int colId=0; colId<wb; colId++) {
        val = 0;
        for (int k=0; k<wa; k++) {
            val += A[rowId * wa + k] * B[k * wb + colId];
        }
        C[rowId * wb + colId] = val;
    }
}

__global__ void matMulCol (int* A, int* B, int* C, int ha, int wa) {
    int colId = threadIdx.x, val;
    int wb = blockDim.x;
    for (int rowId=0; rowId<ha; rowId++) {
        val = 0;
        for (int k=0; k<wa; k++) {
            val += A[rowId * wa + k] * B[k * wb + colId];
        }
        C[rowId * wb + colId] = val;
    }
}

__global__ void matMulElement (int* A, int* B, int* C, int wa) {
    int rowId = threadIdx.x, colId = threadIdx.y;
    int wb = blockDim.y;
    int val = 0;
    for (int k=0; k<wa; k++) {
        val += A[rowId * wa + k] * B[k * wb + colId];
    }
    C[rowId * wb + colId] = val;
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
    int ha, wa, hb, wb;

    printf("Enter number of rows of matrix A: ");
    scanf(" %d", &ha);
    printf("Enter number of columns of matrix A: ");
    scanf(" %d", &wa);
    printf("Enter number of rows of matrix B: ");
    scanf(" %d", &hb);
    printf("Enter number of columns of matrix B: ");
    scanf(" %d", &wb);

    int A[ha*wa], B[hb*wb], C[ha*wb], *d_A, *d_B, *d_C;

    printf("Enter %d elements of matrix A:\n", ha*wa);

    for (int i=0; i<ha*wa; i++) {
        scanf(" %d", A+i);
    }

    printf("Enter %d elements of matrix B:\n", hb*wb);

    for (int i=0; i<hb*wb; i++) {
        scanf(" %d", B+i);
    }

    cudaMalloc((void **) &d_A, ha * wa * sizeof(int));
    cudaMalloc((void **) &d_B, hb * wb * sizeof(int));
    cudaMalloc((void **) &d_C, ha * wb * sizeof(int));

    cudaMemcpy(d_A, A, ha * wa * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B, hb * wb * sizeof(int), cudaMemcpyHostToDevice);

    int x = -1;
    while (1) {
        printf("\n1: Row-wise \n2: Column-wise \n3: Element-wise \n0: Exit \nEnter method to use for multiplication: ");
        scanf(" %d", &x);
        if (x == 0) {
            printf("Exiting...\n");
            break;
        }

        if (x == 1)
            matMulRow <<< 1, ha >>> (d_A, d_B, d_C, wa, wb);
        else if (x == 2)
            matMulCol <<< 1, wb >>> (d_A, d_B, d_C, ha, wa);
        else {
            dim3 blockDim(ha, wb);
            matMulElement <<< 1, blockDim >>> (d_A, d_B, d_C, wa);
        }
            
        cudaMemcpy(C, d_C, ha * wb * sizeof(int), cudaMemcpyDeviceToHost);
    
        printf("\nResultant matrix C:\n");
        displayMatrix(C, ha, wb);
    }

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
}
