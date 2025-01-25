#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "mpi.h"
#include "string.h"

void myAvg( int *in, float *inout, int *len, MPI_Datatype *dptr ) 
{ 
    inout = (float*) inout;
    in = (int*) in;
    *inout = 0;
    for (int i=0; i< *len; i++) { 
            *inout += *(in + i);
    }
    *inout /= *len;
    return; 
} 


float find_avg(int *arr, int n) {
    float sum = 0;
    for(int i=0; i<n; i++) {
        sum += arr[i];
    }
    return sum / n; 
}

int main(int argc, char* argv[]) {
    MPI_Op myOp; 
    MPI_Op_create( myAvg, true, &myOp ); 

    int rank, size, m;
    float num;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Status status;

    int *arr, *colsum;
    float result_arr[size];

    if (rank == 0) {
        printf("Enter the number of columns:\n");
        scanf(" %d", &m);
        arr = (int*) calloc(size*m, sizeof(int));
        colsum = (int*) calloc(m, sizeof(int));
        for(int i=0; i<size; i++){
            printf("Enter elements in row %d:\n", i+1);
            for(int j=0; j<m; j++){
                scanf(" %d", arr+(m*i)+j);
            }
        }
    }
    MPI_Bcast(&m, 1, MPI_INT, 0, MPI_COMM_WORLD);
    int recv_arr[m];

    MPI_Scatter(arr, m, MPI_INT, recv_arr, m, MPI_INT, 0, MPI_COMM_WORLD);

    // num = find_avg(recv_arr, m);

    MPI_Reduce(recv_arr, colsum, m, MPI_FLOAT, myOp, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        printf("Averages:\n");
        for(int i=0; i<m; i++) {
            printf("%.2f ", colsum[i]);
        }
        printf("\n");
    }
    return 0;
}