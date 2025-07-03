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

# Executar no Windows
test-windows: $(TARGET)
	powershell "Get-Content referencias.txt | .\$(TARGET).exe 4"

.PHONY: clean test test-simple test-windows
