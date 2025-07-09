# Simulador de Algoritmos de Substituição de Páginas

Este programa simula três algoritmos clássicos de substituição de páginas em sistemas de memória virtual:
- **FIFO** (First In, First Out)
- **LRU** (Least Recently Used)
- **OPT** (Optimal/Ótimo)

## 📋 Pré-requisitos

- Compilador GCC instalado no sistema
- Sistema operacional Windows (CMD ou PowerShell)

## 🔨 Compilação

Para compilar o programa, execute o seguinte comando no terminal:

```bash
gcc main.c -o main.exe
```

## 🚀 Execução

### Sintaxe
```bash
main.exe <numero_de_quadros> < arquivo_de_referencias
```

Onde:
- `<numero_de_quadros>`: Número de quadros de página disponíveis na memória
- `<arquivo_de_referencias>`: Arquivo contendo a sequência de referências às páginas

## 📄 Exemplos de Uso

### No CMD:
```cmd
# Compilar o programa
gcc main.c -o main.exe

# Teste com arquivo1.txt usando 4 quadros
main.exe 4 < arquivo1.txt

# Teste com arquivo2.txt usando 3 quadros
main.exe 3 < arquivo2.txt

# Teste com vsim-gcc.txt usando 64 quadros
main.exe 64 < vsim-gcc.txt

# Teste com vsim-gcc.txt usando 256 quadros
main.exe 256 < vsim-gcc.txt

# Teste com vsim-gcc.txt usando 1024 quadros
main.exe 1024 < vsim-gcc.txt

# Teste com vsim-gcc.txt usando 4096 quadros
main.exe 4096 < vsim-gcc.txt

# Comparação com diferentes números de quadros
main.exe 1 < arquivo1.txt
main.exe 2 < arquivo1.txt
main.exe 3 < arquivo1.txt
main.exe 4 < arquivo1.txt
main.exe 5 < arquivo1.txt
main.exe 6 < arquivo1.txt
main.exe 7 < arquivo1.txt
```

### No PowerShell:
```powershell
# Compilar o programa
gcc main.c -o main.exe

# Teste com arquivo1.txt usando 4 quadros
Get-Content arquivo1.txt | .\main.exe 4

# Teste com arquivo2.txt usando 3 quadros
Get-Content arquivo2.txt | .\main.exe 3

# Teste com vsim-gcc.txt usando 64 quadros
Get-Content vsim-gcc.txt | .\main.exe 64

# Teste com vsim-gcc.txt usando 256 quadros
Get-Content vsim-gcc.txt | .\main.exe 256

# Teste com vsim-gcc.txt usando 1024 quadros
Get-Content vsim-gcc.txt | .\main.exe 1024

# Teste com vsim-gcc.txt usando 4096 quadros
Get-Content vsim-gcc.txt | .\main.exe 4096

# Comparação com diferentes números de quadros
Get-Content arquivo1.txt | .\main.exe 1
Get-Content arquivo1.txt | .\main.exe 2
Get-Content arquivo1.txt | .\main.exe 3
Get-Content arquivo1.txt | .\main.exe 4
Get-Content arquivo1.txt | .\main.exe 5
Get-Content arquivo1.txt | .\main.exe 6
Get-Content arquivo1.txt | .\main.exe 7
```

## 📊 Formato da Saída

O programa exibe uma linha com os resultados dos três algoritmos:

```
    X quadros,       Y refs: FIFO:     Z PFs, LRU:     W PFs, OPT:     V PFs
```

Onde:
- `X`: Número de quadros de memória utilizados
- `Y`: Total de referências processadas
- `Z`: Número de page faults do algoritmo FIFO
- `W`: Número de page faults do algoritmo LRU
- `V`: Número de page faults do algoritmo OPT

### Exemplo de saída:
```
    4 quadros,      12 refs: FIFO:     6 PFs, LRU:     7 PFs, OPT:     5 PFs
```

## 🧪 Testes Principais

### Arquivos 1 e 2 (1 a 7 quadros):
```cmd
# CMD
for %i in (1 2 3 4 5 6 7) do main.exe %i < arquivo1.txt

# PowerShell
1..7 | ForEach-Object { Get-Content arquivo1.txt | .\main.exe $_ }
```

### Arquivo vsim-gcc.txt (64, 256, 1024, 4096 quadros):
```cmd
# CMD
main.exe 64 < vsim-gcc.txt
main.exe 256 < vsim-gcc.txt
main.exe 1024 < vsim-gcc.txt
main.exe 4096 < vsim-gcc.txt

# PowerShell
64,256,1024,4096 | ForEach-Object { Get-Content vsim-gcc.txt | .\main.exe $_ }
```

## ⚠️ Notas Importantes

- O programa lê as referências de páginas da entrada padrão
- O algoritmo OPT sempre apresenta o menor número de page faults (ótimo teórico)
- FIFO e LRU podem variar dependendo do padrão de acesso às páginas
- Para arquivos grandes como vsim-gcc.txt, o processamento pode levar alguns segundos
