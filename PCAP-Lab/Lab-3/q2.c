#include <stdio.h>
#include <stdlib.h>
#include "mpi.h"
#include "string.h"

float find_avg(int *arr, int n) {
    float sum = 0;
    for(int i=0; i<n; i++) {
        sum += arr[i];
    }
    return sum / n; 
}

int main(int argc, char* argv[]) {
    int rank, size, m;
    float num;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Status status;

    int *arr;
    float result_arr[size];

    if (rank == 0) {
        printf("Enter the number of columns:\n");
        scanf(" %d", &m);
        arr = (int*) calloc(size*m, sizeof(int));
        for(int i=0; i<size; i++){
            //arr[i] = (int*) calloc(m, sizeof(int));
            printf("Enter elements in row %d:\n", i+1);
            for(int j=0; j<m; j++){
                scanf(" %d", arr+(m*i)+j);
            }
        }
    }
    MPI_Bcast(&m, 1, MPI_INT, 0, MPI_COMM_WORLD);
    int recv_arr[m];

    MPI_Scatter(arr, m, MPI_INT, recv_arr, m, MPI_INT, 0, MPI_COMM_WORLD);

    num = find_avg(recv_arr, m);

    MPI_Gather(&num, 1, MPI_FLOAT, result_arr, 1, MPI_FLOAT, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        printf("Averages:\n");
        for(int i=0; i<size; i++) {
            printf("%.2f ", result_arr[i]);
        }
        printf("\n");
    }
    return 0;
}