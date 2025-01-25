#include <stdio.h>
#include "mpi.h"
#include "string.h"

int main(int argc, char* argv[]) {
    int rank, size, str_length, len_in_process;
    char str[100], str1[100], str2[100];
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Status status;

    if (rank == 0) {
        printf("Enter the 2 strings (of same length evenly divisible by %d):\n", size);
        scanf(" %s", str1);
        scanf(" %s", str2);
        str_length = strlen(str1);
        len_in_process = str_length / size;
    }

    MPI_Bcast(&len_in_process, 1, MPI_INT, 0, MPI_COMM_WORLD);
    char ch[len_in_process * 2];
    MPI_Scatter(str1, len_in_process, MPI_CHAR, ch, len_in_process, MPI_CHAR, 0, MPI_COMM_WORLD);
    MPI_Scatter(str2, len_in_process, MPI_CHAR, ch+len_in_process, len_in_process, MPI_CHAR, 0, MPI_COMM_WORLD);

    for(int i=0; i<len_in_process*2; i++){
        printf("%d-%c ", rank, ch[i]);
    }
    printf("\n");

    MPI_Gather(ch, len_in_process*2, MPI_CHAR, str, len_in_process*2, MPI_CHAR, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        str[str_length*2] = '\0';
        printf("Result: %s %d\n", str, strlen(str));
    }
    return 0;
}