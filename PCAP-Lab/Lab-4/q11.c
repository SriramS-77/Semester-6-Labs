#include <stdio.h>
#include "mpi.h"
#include "string.h"

#define C MPI_COMM_WORLD

double fact(int n) {
    if (n==1) {
        return 1;
    }
    return n * fact(n-1); 
}

int main(int argc, char* argv[]) {
    int rank, size;
    int errcode;
    double num;
    int sum;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(C, &rank);
    MPI_Comm_size(C, &size);

    num = fact(rank + 1);
    
    errcode = MPI_Scan(&num, &sum, 2, MPI_INT, MPI_SUM, C);

    if (errcode != MPI_SUCCESS) {
        char error_string[MPI_MAX_ERROR_STRING];
        int length;
        MPI_Error_string(errcode, error_string, &length);
        printf("Error in MPI_Scan: %s\n", error_string);
    } 
    else {
        printf("MPI_Scan proceeded without any error.\n");
    }

    printf("%d ---> %d \n", rank, sum);
    return 0;
}