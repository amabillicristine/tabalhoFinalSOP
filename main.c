#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <stdbool.h>

#define MAX_REFERENCES 1000
#define MAX_PAGES 100

// Estrutura para armazenar as referências
typedef struct {
    int pages[MAX_REFERENCES];
    int count;
} References;

// Função para ler as referências da entrada padrão
References read_references() {
    References refs;
    refs.count = 0;
    int page;
    
    while (scanf("%d", &page) == 1 && refs.count < MAX_REFERENCES) {
        refs.pages[refs.count++] = page;
    }
    
    return refs;
}

// Função para verificar se uma página está na memória
bool is_page_in_memory(int *memory, int num_frames, int page) {
    for (int i = 0; i < num_frames; i++) {
        if (memory[i] == page) {
            return true;
        }
    }
    return false;
}

// Função para encontrar uma posição vazia na memória
int find_empty_frame(int *memory, int num_frames) {
    for (int i = 0; i < num_frames; i++) {
        if (memory[i] == -1) {
            return i;
        }
    }
    return -1;
}

// Algoritmo FIFO
int simulate_fifo(References refs, int num_frames) {
    int *memory = (int*)malloc(num_frames * sizeof(int));
    int page_faults = 0;
    int fifo_index = 0;
    
    // Inicializar memória
    for (int i = 0; i < num_frames; i++) {
        memory[i] = -1;
    }
    
    printf("\n=== ALGORITMO FIFO ===\n");
    printf("Referências: ");
    for (int i = 0; i < refs.count; i++) {
        printf("%d ", refs.pages[i]);
    }
    printf("\n");
    
    for (int i = 0; i < refs.count; i++) {
        int page = refs.pages[i];
        
        if (!is_page_in_memory(memory, num_frames, page)) {
            // Page fault
            page_faults++;
            
            // Encontrar posição vazia ou usar FIFO
            int frame = find_empty_frame(memory, num_frames);
            if (frame == -1) {
                frame = fifo_index;
                fifo_index = (fifo_index + 1) % num_frames;
            }
            
            memory[frame] = page;
            
            printf("Página %d - FAULT | Memória: ", page);
            for (int j = 0; j < num_frames; j++) {
                if (memory[j] == -1) {
                    printf("[ ] ");
                } else {
                    printf("[%d] ", memory[j]);
                }
            }
            printf("\n");
        } else {
            printf("Página %d - HIT   | Memória: ", page);
            for (int j = 0; j < num_frames; j++) {
                if (memory[j] == -1) {
                    printf("[ ] ");
                } else {
                    printf("[%d] ", memory[j]);
                }
            }
            printf("\n");
        }
    }
    
    free(memory);
    return page_faults;
}

// Algoritmo OPT
int simulate_opt(References refs, int num_frames) {
    int *memory = (int*)malloc(num_frames * sizeof(int));
    int page_faults = 0;
    
    // Inicializar memória
    for (int i = 0; i < num_frames; i++) {
        memory[i] = -1;
    }
    
    printf("\n=== ALGORITMO OPT ===\n");
    printf("Referências: ");
    for (int i = 0; i < refs.count; i++) {
        printf("%d ", refs.pages[i]);
    }
    printf("\n");
    
    for (int i = 0; i < refs.count; i++) {
        int page = refs.pages[i];
        
        if (!is_page_in_memory(memory, num_frames, page)) {
            // Page fault
            page_faults++;
            
            // Encontrar posição vazia
            int frame = find_empty_frame(memory, num_frames);
            
            if (frame == -1) {
                // Encontrar a página que será usada mais tarde (ou nunca)
                int farthest = -1;
                int victim_frame = 0;
                
                for (int j = 0; j < num_frames; j++) {
                    int next_use = INT_MAX;
                    
                    // Procurar próxima ocorrência desta página
                    for (int k = i + 1; k < refs.count; k++) {
                        if (refs.pages[k] == memory[j]) {
                            next_use = k;
                            break;
                        }
                    }
                    
                    if (next_use > farthest) {
                        farthest = next_use;
                        victim_frame = j;
                    }
                }
                
                frame = victim_frame;
            }
            
            memory[frame] = page;
            
            printf("Página %d - FAULT | Memória: ", page);
            for (int j = 0; j < num_frames; j++) {
                if (memory[j] == -1) {
                    printf("[ ] ");
                } else {
                    printf("[%d] ", memory[j]);
                }
            }
            printf("\n");
        } else {
            printf("Página %d - HIT   | Memória: ", page);
            for (int j = 0; j < num_frames; j++) {
                if (memory[j] == -1) {
                    printf("[ ] ");
                } else {
                    printf("[%d] ", memory[j]);
                }
            }
            printf("\n");
        }
    }
    
    free(memory);
    return page_faults;
}

// Algoritmo LRU
int simulate_lru(References refs, int num_frames) {
    int *memory = (int*)malloc(num_frames * sizeof(int));
    int *last_used = (int*)malloc(num_frames * sizeof(int));
    int page_faults = 0;
    
    // Inicializar memória e contadores
    for (int i = 0; i < num_frames; i++) {
        memory[i] = -1;
        last_used[i] = -1;
    }
    
    printf("\n=== ALGORITMO LRU ===\n");
    printf("Referências: ");
    for (int i = 0; i < refs.count; i++) {
        printf("%d ", refs.pages[i]);
    }
    printf("\n");
    
    for (int i = 0; i < refs.count; i++) {
        int page = refs.pages[i];
        
        // Verificar se a página já está na memória
        int page_frame = -1;
        for (int j = 0; j < num_frames; j++) {
            if (memory[j] == page) {
                page_frame = j;
                break;
            }
        }
        
        if (page_frame != -1) {
            // Hit: atualizar tempo de uso
            last_used[page_frame] = i;
            
            printf("Página %d - HIT   | Memória: ", page);
            for (int j = 0; j < num_frames; j++) {
                if (memory[j] == -1) {
                    printf("[ ] ");
                } else {
                    printf("[%d] ", memory[j]);
                }
            }
            printf("\n");
        } else {
            // Page fault
            page_faults++;
            
            // Encontrar posição vazia
            int frame = find_empty_frame(memory, num_frames);
            
            if (frame == -1) {
                // Encontrar a página menos recentemente usada
                int lru_time = INT_MAX;
                int lru_frame = 0;
                
                for (int j = 0; j < num_frames; j++) {
                    if (last_used[j] < lru_time) {
                        lru_time = last_used[j];
                        lru_frame = j;
                    }
                }
                
                frame = lru_frame;
            }
            
            memory[frame] = page;
            last_used[frame] = i;
            
            printf("Página %d - FAULT | Memória: ", page);
            for (int j = 0; j < num_frames; j++) {
                if (memory[j] == -1) {
                    printf("[ ] ");
                } else {
                    printf("[%d] ", memory[j]);
                }
            }
            printf("\n");
        }
    }
    
    free(memory);
    free(last_used);
    return page_faults;
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Uso: %s <numero_de_quadros>\n", argv[0]);
        printf("Exemplo: %s 4 < referencias.txt\n", argv[0]);
        return 1;
    }
    
    int num_frames = atoi(argv[1]);
    if (num_frames <= 0) {
        printf("Erro: O número de quadros deve ser maior que 0\n");
        return 1;
    }
    
    printf("Simulador de Algoritmos de Substituição de Páginas\n");
    printf("Número de quadros na RAM: %d\n", num_frames);
    
    // Ler referências
    References refs = read_references();
    
    if (refs.count == 0) {
        printf("Erro: Nenhuma referência foi lida\n");
        return 1;
    }
    
    printf("Total de referências lidas: %d\n", refs.count);
    
    // Simular algoritmos
    int fifo_faults = simulate_fifo(refs, num_frames);
    int opt_faults = simulate_opt(refs, num_frames);
    int lru_faults = simulate_lru(refs, num_frames);
    
    // Mostrar resultados
    printf("\n=== RESULTADOS ===\n");
    printf("FIFO: %d page faults (%.2f%% da taxa de falta)\n", 
           fifo_faults, (float)fifo_faults / refs.count * 100);
    printf("OPT:  %d page faults (%.2f%% da taxa de falta)\n", 
           opt_faults, (float)opt_faults / refs.count * 100);
    printf("LRU:  %d page faults (%.2f%% da taxa de falta)\n", 
           lru_faults, (float)lru_faults / refs.count * 100);
    
    return 0;
}