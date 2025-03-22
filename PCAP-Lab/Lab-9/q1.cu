#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"


__global__ void sparseMatVecMul (int* data, int* data_cols, int *rows, int* V, int* C, int n) {
    int rowId = threadIdx.x;
    int sum = 0;
    for (int i=rows[rowId]; i<rows[rowId+1]; i++) {
        sum += data[i] * V[data_cols[i]];
    }
    printf("%d ---> %d\n", rowId, sum);
    C[rowId] = sum;
}


int main () {
    int ha, wa;

    printf("Enter number of rows of matrix A: ");
    scanf(" %d", &ha);
    printf("Enter number of columns of matrix A: ");
    scanf(" %d", &wa);

    int A[ha*wa], C[ha], V[wa], *d_data, *d_data_cols, *d_rows, *d_V, *d_C, n = 0;

    printf("Enter %d elements of matrix A:\n", ha*wa);

    for (int i=0; i<ha*wa; i++) {
        scanf(" %d", A+i);
        if (A[i] != 0)
            n++;
    }

    printf("Enter %d elements of vector:\n", wa);

    for (int i=0; i<wa; i++) {
        scanf(" %d", V+i);
    }

    int data[n], data_cols[n], rows[n+1], k=0;
    rows[0] = 0;

    for (int i=0; i<ha; i++) {
        rows[i+1] = rows[i];
        for (int j=0; j<wa; j++) {
            if (A[i*wa+j] != 0) {
                data[k] = A[i*wa+j];
                data_cols[k] = j;
                rows[i+1]++;
                k++;
            }
        }
    }

    for (int i=0; i<wa*ha; i++) {
        printf("%d ", A[i]);
    }
    printf("\n");
    for (int i=0; i<n; i++) {
        printf("%d ", data[i]);
    }
    printf("\n");
    for (int i=0; i<n; i++) {
        printf("%d ", data_cols[i]);
    }
    printf("\n");
    for (int i=0; i<ha+1; i++) {
        printf("%d ", rows[i]);
    }
    printf("\n");

    cudaMalloc((void **) &d_data, n * sizeof(int));
    cudaMalloc((void **) &d_data_cols, n * sizeof(int));
    cudaMalloc((void **) &d_rows, (ha+1) * sizeof(int));
    cudaMalloc((void **) &d_V, wa * sizeof(int));
    cudaMalloc((void **) &d_C, ha * sizeof(int));

    cudaMemcpy(d_data, data, n * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_data_cols, data_cols, n * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_rows, rows, (ha+1) * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_V, V, wa * sizeof(int), cudaMemcpyHostToDevice);

    sparseMatVecMul <<< 1, ha >>> (d_data, d_data_cols, d_rows, d_V, d_C, n);

    cudaMemcpy(C, d_C, ha * sizeof(int), cudaMemcpyDeviceToHost);

    printf("Resultant vector:\n");
    for (int i=0; i<ha; i++) {
        printf("%d ", C[i]);
    }
    printf("\n");

    cudaFree(d_data);
    cudaFree(d_data_cols);
    cudaFree(d_rows);
    cudaFree(d_V);
    cudaFree(d_C);
}
