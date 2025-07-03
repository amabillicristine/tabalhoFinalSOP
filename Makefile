# Makefile para o Simulador de Memória Virtual

CC = gcc
CFLAGS = -Wall -Wextra -std=c99
TARGET = simula_memoria_virtual
SOURCE = main.c

# Compilar o programa
$(TARGET): $(SOURCE)
	$(CC) $(CFLAGS) $(SOURCE) -o $(TARGET)

# Limpar arquivos compilados
clean:
	rm -f $(TARGET) $(TARGET).exe

# Executar teste com arquivo de exemplo
test: $(TARGET)
	./$(TARGET) 4 < referencias.txt

# Executar teste com entrada simples
test-simple: $(TARGET)
	echo -e "1\n2\n3\n4\n1\n2\n5\n1\n2\n3\n4\n5" | ./$(TARGET) 3

# Executar teste com arquivo vsim-gcc (primeiras 100 referências)
test-vsim: $(TARGET)
	head -100 vsim-gcc.txt | ./$(TARGET) 4
	head -100 vsim-gcc.txt | ./$(TARGET) 8
	head -100 vsim-gcc.txt | ./$(TARGET) 16

# Executar teste completo com vsim-gcc
test-vsim-full: $(TARGET)
	./$(TARGET) 4 < vsim-gcc.txt

# Executar no Windows
test-windows: $(TARGET)
	powershell "Get-Content referencias.txt | .\$(TARGET).exe 4"

# Executar teste vsim no Windows
test-vsim-windows: $(TARGET)
	powershell "Get-Content vsim-gcc.txt | Select-Object -First 100 | .\$(TARGET).exe 4"
	powershell "Get-Content vsim-gcc.txt | Select-Object -First 100 | .\$(TARGET).exe 8"
	powershell "Get-Content vsim-gcc.txt | Select-Object -First 100 | .\$(TARGET).exe 16"

.PHONY: clean test test-simple test-vsim test-vsim-full test-windows test-vsim-windows
