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

### Exemplos de Uso

#### No PowerShell:
```powershell
# Exemplo com 4 quadros de memória
.\main.exe 4 < arquivo1.txt

# Exemplo com 3 quadros de memória
.\main.exe 3 < arquivo2.txt

# Usando Get-Content (alternativa)
Get-Content arquivo1.txt | .\main.exe 4
```

#### No CMD:
```cmd
# Exemplo com 4 quadros de memória
main.exe 4 < arquivo1.txt

# Usando type (alternativa)
type arquivo1.txt | main.exe 4
```

## 📄 Formato do Arquivo de Entrada

O arquivo de entrada deve conter uma sequência de números inteiros separados por espaços ou quebras de linha, representando as páginas referenciadas.

**Exemplo de arquivo de entrada (`arquivo1.txt`):**
```
1 2 3 4 1 2 5 1 2 3 4 5
```

ou

```
1
2
3
4
1
2
5
1
2
3
4
5
```

## 📊 Formato da Saída

O programa exibe uma linha com os resultados dos três algoritmos:

```
    X quadros,       Y refs, FIFO:     Z PFs, LRU:     W PFs, OPT:     V PFs
```

Onde:
- `X`: Número de quadros de memória utilizados
- `Y`: Total de referências processadas
- `Z`: Número de page faults do algoritmo FIFO
- `W`: Número de page faults do algoritmo LRU
- `V`: Número de page faults do algoritmo OPT

**Exemplo de saída:**
```
    4 quadros,      12 refs, FIFO:     6 PFs, LRU:     7 PFs, OPT:     5 PFs
```

## 🧪 Exemplo Completo

1. **Criar arquivo de teste** (`teste.txt`):
   ```
   7 0 1 2 0 3 0 4 2 3 0 3 2
   ```

2. **Compilar o programa**:
   ```bash
   gcc main.c -o main.exe
   ```

3. **Executar com 3 quadros**:
   ```bash
   .\main.exe 3 < teste.txt
   ```

4. **Resultado esperado**:
   ```
       3 quadros,      13 refs, FIFO:     9 PFs, LRU:    10 PFs, OPT:     7 PFs
   ```

## 📈 Interpretação dos Resultados

- **Page Fault (PF)**: Ocorre quando uma página referenciada não está presente na memória
- **FIFO**: Remove a página que está há mais tempo na memória
- **LRU**: Remove a página que foi usada há mais tempo
- **OPT**: Remove a página que será usada mais tarde no futuro (algoritmo ótimo teórico)

**Observação**: O algoritmo OPT sempre apresenta o menor número de page faults, pois conhece toda a sequência de referências futuras.

## ⚠️ Limitações

- Máximo de 100.000 referências por execução
- O programa lê todas as referências antes de iniciar a simulação
- Entrada deve ser fornecida via redirecionamento ou pipe

## 🐛 Solução de Problemas

### Erro: "Uso: main.exe <num_quadros>"
- Certifique-se de fornecer exatamente um argumento (número de quadros)

### Programa não executa
- Verifique se o GCC está instalado: `gcc --version`
- Verifique se o arquivo foi compilado corretamente

### Arquivo não encontrado
- Verifique se o arquivo de entrada existe no diretório atual
- Use caminho absoluto se necessário: `.\main.exe 4 < C:\caminho\para\arquivo.txt`
