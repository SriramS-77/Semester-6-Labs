#include <stdio.h>
#include "mpi.h"
#include "string.h"

void toggle(char *str) {
    while (*str != '\0') {
        *str += 32;
        str++;
    }
}

int main(int argc, char* argv[])
{
    char s[100];
    int rank, size, len;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Status status;
    if (rank==0) {
        printf("0: Enter the string: \n");
        scanf(" %s", s);
        len = strlen(s);
        printf("0: Sending %s\n", s);
        MPI_Send(s, len, MPI_CHAR, 1, 1, MPI_COMM_WORLD);
        printf("0: Sent\n");
        MPI_Recv(s, len, MPI_CHAR, 1, 1, MPI_COMM_WORLD, &status);
        printf("0: Received %s\n", s);
    }
    else {
        printf("1: Waiting to receive...\n");
        MPI_Recv(s, 5, MPI_CHAR, 0, 1, MPI_COMM_WORLD, &status);
        printf("1: Received %s\n", s);
        toggle(s);
        MPI_Send(s, 5, MPI_CHAR, 0, 1, MPI_COMM_WORLD);
        printf("1: Sent %s\n", s);
    }
    return 0;
}