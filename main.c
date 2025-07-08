#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

#define MAX_REFS 1000000

// FIFO
int simula_fifo(int frames, int* refs, int n_refs) {
    int memoria[frames];
    int pos = 0;
    int page_faults = 0;
    int i, j, encontrado;

    for (i = 0; i < frames; i++) {
        memoria[i] = -1;
    }

    for (i = 0; i < n_refs; i++) {
        encontrado = 0;
        for (j = 0; j < frames; j++) {
            if (memoria[j] == refs[i]) {
                encontrado = 1;
                break;
            }
        }

        if (!encontrado) {
            memoria[pos] = refs[i];
            pos = (pos + 1) % frames;
            page_faults++;
        }
    }

    return page_faults;
}

// LRU
int simula_lru(int frames, int* refs, int n_refs) {
    int memoria[frames];
    int ultima_vez[frames];
    int page_faults = 0;
    int i, j, encontrado;

    for (i = 0; i < frames; i++) {
        memoria[i] = -1;
        ultima_vez[i] = -1;
    }

    for (i = 0; i < n_refs; i++) {
        encontrado = 0;
        for (j = 0; j < frames; j++) {
            if (memoria[j] == refs[i]) {
                ultima_vez[j] = i;
                encontrado = 1;
                break;
            }
        }

        if (!encontrado) {
            int lru_index = 0;
            for (j = 1; j < frames; j++) {
                if (ultima_vez[j] < ultima_vez[lru_index]) {
                    lru_index = j;
                }
            }
            memoria[lru_index] = refs[i];
            ultima_vez[lru_index] = i;
            page_faults++;
        }
    }

    return page_faults;
}

// Otimo (OPT)
int simula_opt(int frames, int* refs, int n_refs) {
    int memoria[frames];
    int page_faults = 0;
    int i, j, k, encontrado;

    for (i = 0; i < frames; i++) {
        memoria[i] = -1;
    }

    for (i = 0; i < n_refs; i++) {
        encontrado = 0;
        for (j = 0; j < frames; j++) {
            if (memoria[j] == refs[i]) {
                encontrado = 1;
                break;
            }
        }

        if (!encontrado) {
            int substitui_index = -1;
            int mais_distante = -1;

            for (j = 0; j < frames; j++) {
                int distancia = -1;
                for (k = i + 1; k < n_refs; k++) {
                    if (memoria[j] == refs[k]) {
                        distancia = k;
                        break;
                    }
                }

                if (distancia == -1) { // Nunca mais sera usada
                    substitui_index = j;
                    break;
                }

                if (distancia > mais_distante) {
                    mais_distante = distancia;
                    substitui_index = j;
                }
            }

            memoria[substitui_index] = refs[i];
            page_faults++;
        }
    }

    return page_faults;
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Uso: %s <num_quadros>\n", argv[0]);
        return 1;
    }

    int num_quadros = atoi(argv[1]);
    int* referencias = malloc(MAX_REFS * sizeof(int));
    if (referencias == NULL) {
        fprintf(stderr, "Erro: não foi possível alocar memória\n");
        return 1;
    }
    
    int total_refs = 0;
    int valor;

    while (scanf("%d", &valor) == 1 && total_refs < MAX_REFS) {
        referencias[total_refs++] = valor;
    }

    int pf_fifo = simula_fifo(num_quadros, referencias, total_refs);
    int pf_lru  = simula_lru(num_quadros, referencias, total_refs);
    int pf_opt  = simula_opt(num_quadros, referencias, total_refs);

    printf("%5d quadros, %7d refs, FIFO: %5d PFs, LRU: %5d PFs, OPT: %5d PFs\n",
           num_quadros, total_refs, pf_fifo, pf_lru, pf_opt);
    fflush(stdout);

    free(referencias);
    return 0;
}