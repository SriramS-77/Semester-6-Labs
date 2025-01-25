#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "mpi.h"
#include "string.h"

char vowels[] = {'a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U'};

int find_non_vowels(char* arr, int n) {
    int cnt = 0;
    bool flag;
    for(int i=0; i<n; i++){
        flag = false;
        for(int j=0; j<10; j++){
            if (arr[i] == vowels[j]){
                flag = true;
                break;
            }
        }
        if (!flag)
            cnt++;
    }
    return cnt; 
}

int main(int argc, char* argv[]) {
    int rank, size, str_length, num_nv, *recv_arr, sum_nv = 0;
    char str[100], recv_str[20];
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Status status;

    recv_arr = (int*) calloc(size, sizeof(int));

    if (rank == 0) {
        printf("Enter the string (whose length is evenly divisible by %d):\n", size);    
        scanf(" %s", str);
        str_length = strlen(str);
    }
    
    MPI_Bcast(&str_length, 1, MPI_INT, 0, MPI_COMM_WORLD);

    MPI_Scatter(str, str_length/size, MPI_CHAR, recv_str, str_length/size, MPI_CHAR, 0, MPI_COMM_WORLD);

    num_nv = find_non_vowels(recv_str, str_length/size);

    MPI_Gather(&num_nv, 1, MPI_INT, recv_arr, 1, MPI_INT, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        for(int i=0; i<size; i++) {
            sum_nv += recv_arr[i];
        }
        printf("Number of non-vowels: %d\n", sum_nv);
    }
    return 0;
}