#include <stdio.h>
#include "mpi.h"
#include "string.h"

int fact(int n) {
    if (n==1) {
        return 1;
    }
    return n * fact(n-1); 
}

int main(int argc, char* argv[]) {
    int rank, size, arr[size], num;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Status status;

    if (rank == 0) {
        printf("Enter the %d numbers:\n", size);
        for(int i=0; i<size; i++){
            scanf(" %d", arr+i);
        }
    }
    
    MPI_Scatter(arr, 1, MPI_INT, &num, 1, MPI_INT, 0, MPI_COMM_WORLD);

    num = fact(num);

    MPI_Gather(&num, 1, MPI_INT, arr, 1, MPI_INT, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        printf("Factorials:\n");
        for(int i=0; i<size; i++) {
            printf("%d ", arr[i]);
        }
        printf("\n");
    }
    return 0;
}