#include <stdio.h>
#include "mpi.h"
#include "string.h"

#define C MPI_COMM_WORLD

int main(int argc, char* argv[]) {
    int rank, size, num;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(C, &rank);
    MPI_Comm_size(C, &size);
    MPI_Status status;

    int mat[size][size], arr[size], sum[size];

    if (rank == 0) {
        printf("Enter the %d numbers of %dx%d matrix:\n", size*size, size, size);
        for(int i=0; i<size; i++){
            for(int j=0; j<size; j++)
                scanf(" %d", *(mat+i)+j);
        }
    }
    
    MPI_Scatter(mat, size, MPI_INT, arr, size, MPI_INT, 0, C);

    MPI_Scan(arr, sum, size, MPI_INT, MPI_SUM, C);

    printf("\nRank %d: \n", rank);
    for (int i=0; i<size; i++) 
        printf("%d ", sum[i]);
    return 0;
}