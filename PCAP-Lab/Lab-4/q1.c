#include <stdio.h>
#include "mpi.h"  
#include "string.h"

#define C MPI_COMM_WORLD

int fact(int n) {
    if (n==1) {
        return 1;
    }
    return n * fact(n-1); 
}

int main(int argc, char* argv[]) {
    int rank, size, num, sum;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(C, &rank);
    MPI_Comm_size(C, &size);

    num = fact(rank + 1);
    
    MPI_Scan(&num, &sum, 1, MPI_INT, MPI_SUM, C);

    printf("%d ---> %d \n", rank, sum);
    return 0;
}