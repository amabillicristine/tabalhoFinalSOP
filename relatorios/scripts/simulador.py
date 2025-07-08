#!/usr/bin/env python3
"""
Simulador de Algoritmos de Substituição de Páginas
Versão Python - Não requer compilação
"""

def simulate_fifo(references, num_frames):
    """Simula o algoritmo FIFO"""
    memory = [-1] * num_frames
    page_faults = 0
    fifo_index = 0
    
    for page in references:
        if page not in memory:
            page_faults += 1
            memory[fifo_index] = page
            fifo_index = (fifo_index + 1) % num_frames
    
    return page_faults

def simulate_opt(references, num_frames):
    """Simula o algoritmo OPT (Ótimo)"""
    memory = [-1] * num_frames
    page_faults = 0
    
    for i, page in enumerate(references):
        if page not in memory:
            page_faults += 1
            
            # Encontrar posição vazia
            empty_pos = -1
            for j in range(num_frames):
                if memory[j] == -1:
                    empty_pos = j
                    break
            
            if empty_pos != -1:
                memory[empty_pos] = page
            else:
                # Encontrar página que será usada mais tarde (ou nunca)
                farthest = -1
                victim_pos = 0
                
                for j in range(num_frames):
                    next_use = float('inf')
                    for k in range(i + 1, len(references)):
                        if references[k] == memory[j]:
                            next_use = k
                            break
                    
                    if next_use > farthest:
                        farthest = next_use
                        victim_pos = j
                
                memory[victim_pos] = page
    
    return page_faults

def simulate_lru(references, num_frames):
    """Simula o algoritmo LRU"""
    memory = [-1] * num_frames
    last_used = [-1] * num_frames
    page_faults = 0
    
    for i, page in enumerate(references):
        # Verificar se página está na memória
        page_pos = -1
        for j in range(num_frames):
            if memory[j] == page:
                page_pos = j
                break
        
        if page_pos != -1:
            # Hit: atualizar tempo de uso
            last_used[page_pos] = i
        else:
            # Page fault
            page_faults += 1
            
            # Encontrar posição vazia
            empty_pos = -1
            for j in range(num_frames):
                if memory[j] == -1:
                    empty_pos = j
                    break
            
            if empty_pos != -1:
                memory[empty_pos] = page
                last_used[empty_pos] = i
            else:
                # Encontrar página menos recentemente usada
                lru_time = float('inf')
                lru_pos = 0
                
                for j in range(num_frames):
                    if last_used[j] < lru_time:
                        lru_time = last_used[j]
                        lru_pos = j
                
                memory[lru_pos] = page
                last_used[lru_pos] = i
    
    return page_faults

def main():
    print("=== SIMULADOR DE MEMORIA VIRTUAL ===")
    print("Algoritmos: FIFO, LRU, OPT")
    print("(Versão Python - Não requer compilação)")
    print()
    
    # Obter número de quadros
    while True:
        try:
            num_frames = int(input("Digite o número de quadros na RAM: "))
            if num_frames > 0:
                break
            else:
                print("Erro: O número de quadros deve ser maior que 0")
        except ValueError:
            print("Erro: Digite um número válido")
    
    # Obter referências
    print("\nDigite as referências de páginas (uma por linha).")
    print("Digite -1 para terminar ou deixe vazio e pressione Enter.")
    
    references = []
    ref_count = 1
    
    while True:
        try:
            entrada = input(f"Referência {ref_count}: ").strip()
            
            if entrada == "":
                if references:
                    break
                else:
                    print("Digite pelo menos uma referência")
                    continue
            
            page = int(entrada)
            
            if page == -1:
                break
            
            if page < 0:
                print("Número de página deve ser >= 0")
                continue
            
            references.append(page)
            ref_count += 1
            
        except ValueError:
            print("Erro: Digite um número válido")
    
    if not references:
        print("Erro: Nenhuma referência foi inserida")
        return
    
    print(f"\n=== PROCESSANDO {len(references)} REFERÊNCIAS COM {num_frames} QUADROS ===")
    
    # Simular algoritmos
    fifo_faults = simulate_fifo(references, num_frames)
    opt_faults = simulate_opt(references, num_frames)
    lru_faults = simulate_lru(references, num_frames)
    
    # Mostrar resultados
    print("\n=== RESULTADOS ===")
    print(f"FIFO: {fifo_faults} page faults")
    print(f"LRU:  {lru_faults} page faults")
    print(f"OPT:  {opt_faults} page faults")
    print(f"\nFormato padrão:")
    print(f"{num_frames:5d} quadros, {len(references):7d} refs: FIFO: {fifo_faults:5d} PFs, LRU: {lru_faults:5d} PFs, OPT: {opt_faults:5d} PFs")

if __name__ == "__main__":
    main()
