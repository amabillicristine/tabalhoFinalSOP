@echo off
echo ========================================
echo BATERIA DE TESTES - SIMULADOR DE MEMORIA VIRTUAL
echo ========================================
echo.

echo TESTE 1: Padrao basico (1,2,3,4,1,2,5,1,2,3,4,5) com 3 quadros
echo 1 2 3 4 1 2 5 1 2 3 4 5 | gcc main.c -o temp && temp.exe 3 && del temp.exe
echo.

echo TESTE 2: Sem page faults (1,1,1,1,1) com 1 quadro  
echo 1 1 1 1 1 | gcc main.c -o temp && temp.exe 1 && del temp.exe
echo.

echo TESTE 3: Padrao ciclico (1,2,3,1,2,3) com 2 quadros
echo 1 2 3 1 2 3 | gcc main.c -o temp && temp.exe 2 && del temp.exe
echo.

echo TESTE 4: Comparacao com diferentes quadros - mesmo padrao
echo Padrao: 1 2 3 4 1 2 5 1 2 3 4 5
echo.
echo --- 2 quadros ---
echo 1 2 3 4 1 2 5 1 2 3 4 5 | gcc main.c -o temp && temp.exe 2 && del temp.exe
echo.
echo --- 3 quadros ---  
echo 1 2 3 4 1 2 5 1 2 3 4 5 | gcc main.c -o temp && temp.exe 3 && del temp.exe
echo.
echo --- 4 quadros ---
echo 1 2 3 4 1 2 5 1 2 3 4 5 | gcc main.c -o temp && temp.exe 4 && del temp.exe
echo.

echo ========================================
echo TESTES CONCLUIDOS
echo ========================================
