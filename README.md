# Simulador de Memória Virtual

Simulador dos algoritmos de substituição de páginas: FIFO, LRU e OPT.

## Estrutura do Projeto

```
📁 tabalhoFinalSOP/
├── 📄 main.c                    # Código principal do simulador
├── 📄 Makefile                  # Automação de compilação e testes
├── 📄 README.md                 # Este arquivo
├── 📄 arquivo1.txt              # Arquivo de teste 1 (24 referências)
├── 📄 arquivo2.txt              # Arquivo de teste 2 (30 referências)
├── 📄 vsim-gcc.txt              # Arquivo de teste grande (1M+ referências)
└── 📁 relatorios/               # Pasta com relatórios e análises
    ├── 📄 *.png                 # Gráficos de análise
    ├── 📄 *.csv                 # Dados de performance
    ├── 📄 *.txt                 # Relatórios de teste
    ├── 📄 *.md                  # Documentação adicional
    ├── 📄 *.bat, *.ps1          # Scripts auxiliares
    └── 📁 scripts/              # Scripts Python para análise
        ├── 📄 simulador.py      # Simulador em Python
        ├── 📄 gerar_graficos.py # Geração de gráficos
        └── 📄 teste_rapido.py   # Testes automatizados
```

## Como usar

### Pré-requisitos
- GCC (MinGW no Windows) instalado e configurado no PATH
- Para Windows: instale MinGW-w64 ou use o compilador via MSYS2

### Compilação

#### Windows (CMD/PowerShell)
```cmd
gcc -Wall -Wextra -std=c99 main.c -o simulador.exe
```

#### Linux/Mac
```bash
gcc -Wall -Wextra -std=c99 main.c -o simulador
```

### Execução com arquivos de teste

#### Windows CMD
```cmd
# Testar com arquivo1.txt usando 3 frames
type arquivo1.txt | simulador.exe 3

# Testar com arquivo2.txt usando 4 frames  
type arquivo2.txt | simulador.exe 4

# Testar com vsim-gcc.txt (primeiras 100 linhas) usando 8 frames
powershell "Get-Content vsim-gcc.txt | Select-Object -First 100" | simulador.exe 8
```

#### Windows PowerShell
```powershell
# Testar com arquivo1.txt
Get-Content arquivo1.txt | .\simulador.exe 3

# Testar com arquivo2.txt
Get-Content arquivo2.txt | .\simulador.exe 4

# Testar com vsim-gcc.txt (primeiras 1000 linhas)
Get-Content vsim-gcc.txt | Select-Object -First 1000 | .\simulador.exe 16
```

#### Linux/Mac
```bash
./simulador 3 < arquivo1.txt
./simulador 4 < arquivo2.txt
head -1000 vsim-gcc.txt | ./simulador 16
```

### Execução manual
```bash
# Windows
.\simulador.exe 3

# Linux/Mac
./simulador 3
```
Digite as referências de páginas uma por linha e pressione Ctrl+Z (Windows) ou Ctrl+D (Linux) para finalizar.

### Comando completo (compilar, executar e limpar)

#### Windows CMD
```cmd
gcc -Wall -Wextra -std=c99 main.c -o temp.exe && type arquivo1.txt | temp.exe 3 && del temp.exe
```

#### Windows PowerShell
```powershell
gcc -Wall -Wextra -std=c99 main.c -o temp.exe; if ($?) { Get-Content arquivo1.txt | .\temp.exe 3; Remove-Item temp.exe }
```

## Exemplos de uso

### Teste básico com arquivo1.txt
```cmd
gcc -Wall -Wextra -std=c99 main.c -o simulador.exe
type arquivo1.txt | simulador.exe 3
```
**Saída esperada:**
```
    3 quadros,      24 refs, FIFO:    15 PFs, LRU:    14 PFs, OPT:    11 PFs
```

### Teste com arquivo2.txt
```cmd
type arquivo2.txt | simulador.exe 4
```
**Saída esperada:**
```
    4 quadros,      30 refs, FIFO:    10 PFs, LRU:     8 PFs, OPT:     7 PFs
```

### Teste de performance com vsim-gcc.txt
```cmd
powershell "Get-Content vsim-gcc.txt | Select-Object -First 1000" | simulador.exe 64
```

### Comparação de diferentes números de frames
```cmd
# 2 frames
type arquivo1.txt | simulador.exe 2

# 3 frames  
type arquivo1.txt | simulador.exe 3

# 4 frames
type arquivo1.txt | simulador.exe 4
```

## Makefile (opcional)

Para facilitar os testes, você pode usar os comandos do Makefile:

```cmd
# Compilar e executar sem deixar arquivos
make run-arquivo1

# Testes com diferentes frames
make test-arquivo1-frames

# Testes com arquivo2
make test-arquivo2

# Teste de performance com vsim-gcc
make test-vsim-performance
```

## Notas importantes

- O programa lê as referências de páginas da entrada padrão
- Use números de frames apropriados para cada teste (geralmente 2-16)
- Para arquivos grandes como vsim-gcc.txt, use amostras menores para testes rápidos
- O algoritmo OPT sempre terá o menor número de page faults (é o algoritmo ótimo)
- FIFO e LRU podem variar dependendo do padrão de acesso às páginas
