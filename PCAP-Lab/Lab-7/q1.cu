#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"


__global__ void count (char* str, char* key, int key_len, int* word_lengths, int num_words, int *n) {
    int idx = threadIdx.x;
    // printf("\n%d ---> %d", idx, idx);
    int start_idx = 0, length = word_lengths[idx];
    int flag = 1;
    for (int i=0; i<idx; i++) {
        start_idx += word_lengths[i] + 1;
    }
    if (key_len != length) {
        // printf("\n%d ---> Length Mismatch\n", idx);
        flag = 0;
    }
    

    // printf("%d ---> %d, %d\n", idx, start_idx, length);

    for (int i=start_idx; i<start_idx+length; i++) {
        if (str[i] != key[i-start_idx]) {
            // printf("\n%d ---> Char mismatch %c not in %c\n", idx, str[i], key[i-start_idx]);
            flag = 0;
            break;
        }
    }
    // printf("\n%d ---> %d\n", idx, flag);
    if (flag) {
        atomicAdd(n, 1);
        // printf("--->%d", *n);
    }
}

int main () {
    char str[100], key[10], *d_str, *d_key, ch;
    int n=0, *d_n;
    int word_lengths[50], num_words=1, *d_word_lengths, len_key;

    printf("Enter the words: ");
    fgets(str, 100, stdin);

    printf("Enter the key: ");
    scanf(" %s", key);

    int i=0, j=0;
    while (1) {
        ch = str[i++];
        // printf("ch ---> %c", ch);
        if (ch == '\0') {
            word_lengths[num_words-1] = j;
            break;
        }
        if (ch == ' ') {
            word_lengths[num_words-1] = j;
            j = 0;
            num_words++;
            continue;
        }
        if (ch >= 'a' && ch <= 'z' || ch >= 'A' && ch <= 'Z')
            j++;
    }

    len_key = strlen(key);

    /*
    printf("%s\n", str);
    printf("%s\n", key);
    printf("Num: %d\n", num_words);
    printf("Num_Key: %d\n", len_key);
    for (int i=0; i<num_words; i++) {
        printf("%d ", word_lengths[i]);
    }*/

    cudaMalloc((void **) &d_str, strlen(str) * sizeof(char));
    cudaMalloc((void **) &d_key, strlen(key) * sizeof(char));
    cudaMalloc((void **) &d_word_lengths, num_words * sizeof(int));
    cudaMalloc((void **) &d_n, 1 * sizeof(int));

    cudaMemcpy(d_str, str, strlen(str) * sizeof(char), cudaMemcpyHostToDevice);
    cudaMemcpy(d_key, key, strlen(key) * sizeof(char), cudaMemcpyHostToDevice);
    cudaMemcpy(d_word_lengths, word_lengths, num_words * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_n, &n, 1 * sizeof(int), cudaMemcpyHostToDevice);

    count <<< 1, num_words >>> (d_str, d_key, len_key, d_word_lengths, num_words, d_n);

    cudaMemcpy(&n, d_n, sizeof(int), cudaMemcpyDeviceToHost);

    printf("Frequency of occurrence of key in the sentence: %d\n", n);

    cudaFree(d_str);
    cudaFree(d_key);
    cudaFree(d_word_lengths);
    cudaFree(d_n);
}
