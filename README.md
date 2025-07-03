# Simulador de Algoritmos de Substituição de Páginas

Este programa implementa e simula três algoritmos de substituição de páginas utilizados no gerenciamento de memória virtual:

- **FIFO (First In, First Out)**: Remove a página que está há mais tempo na memória
- **OPT (Algoritmo Ótimo)**: Remove a página que será referenciada mais tarde no futuro (ou nunca)
- **LRU (Least Recently Used)**: Remove a página que foi menos recentemente utilizada

## Compilação

Para compilar o programa, execute:

```bash
gcc main.c -o simula_memoria_virtual
```

## Uso

O programa recebe como parâmetro o número de quadros disponíveis na RAM e lê as referências às páginas da entrada padrão (stdin):

```bash
./simula_memoria_virtual <numero_de_quadros> < arquivo_referencias.txt
```

### Exemplo de uso:

```bash
./simula_memoria_virtual 4 < referencias.txt
```

ou no PowerShell:

```powershell
Get-Content referencias.txt | .\simula_memoria_virtual.exe 4
```

## Formato do arquivo de referências

O arquivo de referências deve conter uma referência de página por linha. Por exemplo:

```
7
0
1
2
0
3
0
4
2
3
```

## Saída do programa

O programa mostra:
1. O estado da memória após cada referência (HIT ou FAULT)
2. Os resultados finais com o número de page faults para cada algoritmo
3. A taxa de page faults em porcentagem

### Exemplo de saída:

```
Simulador de Algoritmos de Substituição de Páginas
Número de quadros na RAM: 4
Total de referências lidas: 20

=== ALGORITMO FIFO ===
Referências: 7 0 1 2 0 3 0 4 2 3 0 3 2 1 2 0 1 7 0 1
Página 7 - FAULT | Memória: [7] [ ] [ ] [ ]
Página 0 - FAULT | Memória: [7] [0] [ ] [ ]
...

=== RESULTADOS ===
FIFO: 10 page faults (50.00% da taxa de falta)
OPT:  8 page faults (40.00% da taxa de falta)
LRU:  8 page faults (40.00% da taxa de falta)
```

## Arquivos incluídos

- `main.c`: Código fonte do simulador
- `referencias.txt`: Arquivo de exemplo com referências de páginas
- `vsim-gcc.txt`: Arquivo grande com referências reais (5+ milhões de referências)
- `teste_pequeno.txt`: Arquivo pequeno para testes rápidos
- `README.md`: Esta documentação
- `Makefile`: Para facilitar compilação e testes

## Testes com arquivo vsim-gcc

O projeto inclui um arquivo real de referências de páginas (`vsim-gcc.txt`) com mais de 5 milhões de referências. Para testes práticos, use amostras menores:

### Resultados de exemplo (50 referências, diferentes números de quadros):

**Com 4 quadros:**
- FIFO: 39 page faults (78.00%)
- OPT: 30 page faults (60.00%) 
- LRU: 38 page faults (76.00%)

**Com 8 quadros:**
- FIFO: 33 page faults (66.00%)
- OPT: 27 page faults (54.00%)
- LRU: 32 page faults (64.00%)

### Comandos para teste com vsim-gcc:

```bash
# Testar com primeiras 50 referências e 4 quadros
Get-Content vsim-gcc.txt | Select-Object -First 50 | .\simula_memoria_virtual.exe 4

# Testar com diferentes números de quadros
Get-Content vsim-gcc.txt | Select-Object -First 100 | .\simula_memoria_virtual.exe 8
Get-Content vsim-gcc.txt | Select-Object -First 100 | .\simula_memoria_virtual.exe 16
```

## Implementação

O programa implementa cada algoritmo de forma clara e educativa:

- **FIFO**: Utiliza um índice circular para controlar qual página remover
- **OPT**: Analisa todas as referências futuras para encontrar a página ótima para remoção
- **LRU**: Mantém um timestamp de último uso para cada página na memória

Cada algoritmo mostra o estado da memória após cada referência, facilitando o entendimento do comportamento de cada estratégia de substituição.