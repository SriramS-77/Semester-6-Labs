#include <stdio.h>
#include <stdlib.h>
#include "mpi.h"
#include "string.h"

int main(int argc, char* argv[])
{
    int rank, size, n, m;
    int *arr;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Status status;
    if (rank==0) {
        arr = (int*) calloc(size, sizeof(int));
        printf("Enter %d numbers:\n", size);
        for (int i=0; i<size; i++) {
            scanf(" %d", arr+i);
        }
        //MPI_Buffer_attach(arr, size * sizeof(int) + MPI_BSEND_OVERHEAD);
        for (int i=1; i<size; i++) {
            printf("0: Sending %d\n", arr[i]);
            MPI_Send(arr+i, 1, MPI_INT, i, i, MPI_COMM_WORLD);
        }
    }
    else {
        MPI_Recv(&n, 1, MPI_INT, 0, rank, MPI_COMM_WORLD, &status);
        m = n * n;
        if (rank % 2 == 1)
            m *= n;
        printf("Rank %d: Received %d. Converted to %d.\n", rank, n, m);
    }
    return 0;
}