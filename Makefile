# Makefile para o Simulador de Memória Virtual

CC = gcc
CFLAGS = -Wall -Wextra -std=c99
TARGET = simulador
SOURCE = main.c

# Compilar e executar interativamente
run: $(SOURCE)
	$(CC) $(CFLAGS) $(SOURCE) -o temp_exec
	temp_exec.exe
	del temp_exec.exe

# Compilar o programa
$(TARGET): $(SOURCE)
	$(CC) $(CFLAGS) $(SOURCE) -o $(TARGET)

# Limpar arquivos
clean:
	if exist $(TARGET).exe del $(TARGET).exe
	if exist temp_*.exe del temp_*.exe

# ===============================================
# TESTES COM ARQUIVOS ORIGINAIS
# ===============================================

# Teste com arquivo1.txt (3 frames)
test-arquivo1: $(SOURCE)
	@echo "=== TESTE ARQUIVO1.TXT (3 frames) ==="
	$(CC) $(CFLAGS) $(SOURCE) -o temp_test
	type arquivo1.txt | temp_test.exe 3
	del temp_test.exe

# Teste com arquivo2.txt (4 frames)
test-arquivo2: $(SOURCE)
	@echo "=== TESTE ARQUIVO2.TXT (4 frames) ==="
	$(CC) $(CFLAGS) $(SOURCE) -o temp_test
	type arquivo2.txt | temp_test.exe 4
	del temp_test.exe

# Teste com vsim-gcc.txt (amostra pequena)
test-vsim-small: $(SOURCE)
	@echo "=== TESTE VSIM-GCC.TXT (primeiras 100 linhas, 8 frames) ==="
	$(CC) $(CFLAGS) $(SOURCE) -o temp_test
	powershell "Get-Content vsim-gcc.txt | Select-Object -First 100" | temp_test.exe 8
	del temp_test.exe

# Teste de performance com vsim-gcc.txt
test-vsim-performance: $(SOURCE)
	@echo "=== TESTE PERFORMANCE VSIM-GCC.TXT (primeiras 1000 linhas) ==="
	$(CC) $(CFLAGS) $(SOURCE) -o temp_test
	@echo "--- 16 frames ---"
	powershell "Get-Content vsim-gcc.txt | Select-Object -First 1000" | temp_test.exe 16
	@echo "--- 32 frames ---"
	powershell "Get-Content vsim-gcc.txt | Select-Object -First 1000" | temp_test.exe 32
	@echo "--- 64 frames ---"
	powershell "Get-Content vsim-gcc.txt | Select-Object -First 1000" | temp_test.exe 64
	del temp_test.exe

# Comparação de frames com arquivo1
test-arquivo1-frames: $(SOURCE)
	@echo "=== COMPARAÇÃO FRAMES - ARQUIVO1.TXT ==="
	$(CC) $(CFLAGS) $(SOURCE) -o temp_test
	@echo "--- 2 frames ---"
	type arquivo1.txt | temp_test.exe 2
	@echo "--- 3 frames ---"
	type arquivo1.txt | temp_test.exe 3
	@echo "--- 4 frames ---"
	type arquivo1.txt | temp_test.exe 4
	@echo "--- 5 frames ---"
	type arquivo1.txt | temp_test.exe 5
	del temp_test.exe

# Comparação de frames com arquivo2
test-arquivo2-frames: $(SOURCE)
	@echo "=== COMPARAÇÃO FRAMES - ARQUIVO2.TXT ==="
	$(CC) $(CFLAGS) $(SOURCE) -o temp_test
	@echo "--- 2 frames ---"
	type arquivo2.txt | temp_test.exe 2
	@echo "--- 3 frames ---"
	type arquivo2.txt | temp_test.exe 3
	@echo "--- 4 frames ---"
	type arquivo2.txt | temp_test.exe 4
	@echo "--- 6 frames ---"
	type arquivo2.txt | temp_test.exe 6
	del temp_test.exe

# Executar todos os testes básicos
test-all-basic: test-arquivo1 test-arquivo2 test-vsim-small

# Executar todos os testes de comparação
test-all-frames: test-arquivo1-frames test-arquivo2-frames

# Executar TODOS os testes
test-all: test-all-basic test-all-frames test-vsim-performance
	@echo ""
	@echo "✅ TODOS OS TESTES CONCLUÍDOS!"
	@echo "📊 Foram executados testes com os arquivos originais:"
	@echo "   - arquivo1.txt (24 referências)"
	@echo "   - arquivo2.txt (30 referências)"  
	@echo "   - vsim-gcc.txt (amostras de 100 e 1000 linhas)"

.PHONY: run clean test-arquivo1 test-arquivo2 test-vsim-small test-vsim-performance test-arquivo1-frames test-arquivo2-frames test-all-basic test-all-frames test-all
