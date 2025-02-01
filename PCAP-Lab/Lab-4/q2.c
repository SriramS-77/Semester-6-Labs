#include <stdio.h>
#include "mpi.h"
#include "string.h"

#define C MPI_COMM_WORLD

int main(int argc, char* argv[]) {
    int rank, size, mat[3][3], arr[3], num;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(C, &rank);
    MPI_Comm_size(C, &size);
    MPI_Status status;

    if (rank == 0) {
        printf("Enter the 9 numbers of 3x3 matrix:\n");
        for(int i=0; i<3; i++){
            for(int j=0; j<3; j++)
                scanf(" %d", *(mat+i)+j);
        }
        printf("\nEnter element to search for: ");
        scanf(" %d", &num);
    }
    
    MPI_Scatter(mat, 3, MPI_INT, arr, 3, MPI_INT, 0, C);

    MPI_Bcast(&num, 1, MPI_INT, 0, C);

    for (int i=0; i<3; i++) {
        if (arr[i] == num)
            printf("%d found in [Rank %d] row %d, column %d \n", num, rank, rank+1, i+1);
    }
    return 0;
}