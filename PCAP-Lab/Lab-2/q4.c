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
        n++;
        printf("%d: Sending %d\n", rank, n);
        MPI_Send(&n, 1, MPI_INT, (rank+1) % size, (rank+1) % size, MPI_COMM_WORLD);
        MPI_Recv(&n, 1, MPI_INT, size-1, rank, MPI_COMM_WORLD, &status);
        printf("0: Received %d\n", n);
    }
    else {
        MPI_Recv(&n, 1, MPI_INT, rank-1, rank, MPI_COMM_WORLD, &status);
        printf("%d: Received %d\n", rank, n);
        n++;
        printf("%d: Sending %d\n", rank, n);
        MPI_Send(&n, 1, MPI_INT, (rank+1) % size, (rank+1) % size, MPI_COMM_WORLD);
    }
    return 0;
}