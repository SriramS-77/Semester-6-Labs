#include <stdio.h>
#include <stdlib.h>
#include "mpi.h"
#include "string.h"

#define C MPI_COMM_WORLD

int result_length(int n) {
    int sum = 0;
    for (int i=1; i<=n; i++) {
        sum += i;
    }
    return sum;
}

void duplicate(char **ch_dup, char ch, int n) {
    *ch_dup = (char*) malloc((n+1) * sizeof(char));
    for (int i=0; i<n; i++)
        (*ch_dup)[i] = ch;
    (*ch_dup)[n] = '\0';
    return;
}

void catch_error(int errcode) {
    if (errcode != MPI_SUCCESS) {
        char error_string[MPI_MAX_ERROR_STRING];
        int length;
        MPI_Error_string(errcode, error_string, &length);
        printf("Error in MPI_Comm: %s\n", error_string);
    } 
    else {
        printf("MPI_Comm proceeded without any error.\n");
    }
    return;
}

int main(int argc, char* argv[]) {
    int rank, size, length, errcode;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(C, &rank);
    MPI_Comm_size(C, &size);
    MPI_Status status;

    MPI_Errhandler_set(C, MPI_ERRORS_RETURN);

    char str[size+1], ch, *ch_dup;
    length = result_length(size);
    char result[length+1];
    result[length] = '\0';

    if (rank == 0) {
        printf("Enter the word of length %d:\n", size);
        scanf(" %s", str);
    }

    MPI_Scatter(str, 1, MPI_CHAR, &ch, 1, MPI_CHAR, 0, C);

    duplicate(&ch_dup, ch, rank+1);

    printf("Rank %d ---> %s \n", rank, ch_dup);

    
    if (rank == 0) {
        result[0] = ch;
        for (int i=1; i<size; i++) {
            errcode = MPI_Recv(result + result_length(i), i-1, MPI_CHAR, i, i, C, &status);
            catch_error(errcode);
        }
        printf("Received at root: %s \n", result);
    }

    else {
        errcode = MPI_Ssend(ch_dup, rank+1, MPI_CHAR, 0, rank, C);
        //catch_error(errcode);
    }

    return 0;
}