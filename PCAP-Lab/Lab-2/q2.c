#include <stdio.h>
#include "mpi.h"
#include "string.h"

int main(int argc, char* argv[])
{
    int rank, size, n;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Status status;
    if (rank==0) {
        printf("0: Enter the starting number: \n");
        scanf(" %d", &n);
        for (int i=1; i<size; i++, n++) {
            MPI_Send(&n, 1, MPI_INT, i, i, MPI_COMM_WORLD);
        }
    }
    else {
        MPI_Recv(&n, 1, MPI_INT, 0, rank, MPI_COMM_WORLD, &status);
        printf("Rank %d: Received %d\n", rank, n);
    }
    return 0;
}