@echo off
setlocal enabledelayedexpansion

:: Script Batch para Execução Completa de Testes do Simulador de Memória Virtual
:: Executa diversos cenários de teste e compila/limpa automaticamente

echo ============================================
echo    SIMULADOR DE MEMÓRIA VIRTUAL - TESTES
echo    Algoritmos: FIFO, OPT, LRU
echo ============================================
echo.

:: Verifica se main.c existe
if not exist main.c (
    echo ❌ Arquivo main.c não encontrado!
    pause
    exit /b 1
)

:: Verifica se gcc está disponível
gcc --version >nul 2>&1
if errorlevel 1 (
    echo ❌ GCC não encontrado! Instale o MinGW ou configure o PATH.
    pause
    exit /b 1
)

echo ✅ GCC encontrado e pronto para uso!
echo.

:: Função para executar teste com arquivo
:executar_teste
set "nome_teste=%~1"
set "arquivo_entrada=%~2"
set "descricao=%~3"

echo 📋 %nome_teste%
echo    %descricao%
echo.

if exist "%arquivo_entrada%" (
    gcc -Wall -Wextra -std=c99 main.c -o temp_test.exe 2>nul
    if !errorlevel! equ 0 (
        temp_test.exe < "%arquivo_entrada%"
        echo.
    ) else (
        echo ❌ Erro na compilação do teste %nome_teste%
    )
    if exist temp_test.exe del temp_test.exe >nul 2>&1
) else (
    echo ❌ Arquivo de teste não encontrado: %arquivo_entrada%
)

echo ----------------------------------------
echo.
goto :eof

:: CATEGORIA 1: TESTES BÁSICOS
echo 🧪 CATEGORIA 1: TESTES BÁSICOS
echo ================================

call :executar_teste "TESTE BÁSICO" "teste_basico.txt" "Caso padrão com 3 frames e sequência mista"

echo 📋 TESTE MÍNIMO
echo    Teste com apenas 1 frame (máximo stress)
echo.
gcc -Wall -Wextra -std=c99 main.c -o temp_test.exe 2>nul
if !errorlevel! equ 0 (
    echo 1
    echo 1
    echo 2
    echo 3
    echo 4
    echo 5
    echo -1
) | temp_test.exe
echo.
if exist temp_test.exe del temp_test.exe >nul 2>&1
echo ----------------------------------------
echo.

call :executar_teste "TESTE SEM PAGE FAULTS" "teste_sem_page_faults.txt" "Referências repetidas - 0 page faults esperados"

:: CATEGORIA 2: TESTES DE VANTAGEM DOS ALGORITMOS
echo 🏆 CATEGORIA 2: TESTES DE VANTAGEM DOS ALGORITMOS
echo ==================================================

call :executar_teste "VANTAGEM OPT" "teste_opt.txt" "Cenário onde OPT deve ter melhor performance"

call :executar_teste "VANTAGEM LRU" "teste_lru_vantagem.txt" "Cenário favorável ao algoritmo LRU"

:: CATEGORIA 3: CASOS ESPECIAIS E ANOMALIAS
echo 🔬 CATEGORIA 3: CASOS ESPECIAIS E ANOMALIAS
echo =============================================

call :executar_teste "ANOMALIA DE BELADY" "teste_belady_anomaly.txt" "Teste para verificar anomalia de Belady no FIFO"

call :executar_teste "TESTE CÍCLICO" "teste_ciclico.txt" "Padrão de acesso cíclico às páginas"

:: CATEGORIA 4: TESTES DE STRESS
echo 💪 CATEGORIA 4: TESTES DE STRESS
echo =================================

call :executar_teste "TESTE DE STRESS" "teste_stress.txt" "Alto volume de referências (40 páginas)"

call :executar_teste "NÚMEROS GRANDES" "teste_grandes_numeros.txt" "Teste com números de página elevados"

call :executar_teste "TESTE COMPLETO" "teste_completo.txt" "Cenário complexo com 10 frames"

:: CATEGORIA 5: TESTES EXTREMOS
echo 🚀 CATEGORIA 5: TESTES EXTREMOS
echo ================================

echo 📋 TESTE SEQUENCIAL
echo    Acesso sequencial puro
echo.
gcc -Wall -Wextra -std=c99 main.c -o temp_test.exe 2>nul
if !errorlevel! equ 0 (
    (echo 5 && echo 1 && echo 2 && echo 3 && echo 4 && echo 5 && echo 6 && echo 7 && echo 8 && echo 9 && echo 10 && echo 11 && echo 12 && echo 13 && echo 14 && echo 15 && echo -1) | temp_test.exe
    echo.
)
if exist temp_test.exe del temp_test.exe >nul 2>&1
echo ----------------------------------------
echo.

echo 📋 TESTE REVERSO
echo    Acesso em ordem reversa
echo.
gcc -Wall -Wextra -std=c99 main.c -o temp_test.exe 2>nul
if !errorlevel! equ 0 (
    (echo 4 && echo 10 && echo 9 && echo 8 && echo 7 && echo 6 && echo 5 && echo 4 && echo 3 && echo 2 && echo 1 && echo -1) | temp_test.exe
    echo.
)
if exist temp_test.exe del temp_test.exe >nul 2>&1
echo ----------------------------------------
echo.

echo 📋 TESTE PING-PONG
echo    Alternância entre duas páginas
echo.
gcc -Wall -Wextra -std=c99 main.c -o temp_test.exe 2>nul
if !errorlevel! equ 0 (
    (echo 2 && echo 1 && echo 2 && echo 1 && echo 2 && echo 1 && echo 2 && echo 1 && echo 2 && echo 1 && echo 2 && echo -1) | temp_test.exe
    echo.
)
if exist temp_test.exe del temp_test.exe >nul 2>&1
echo ----------------------------------------
echo.

:: FINALIZAÇÃO
echo ✅ TODOS OS TESTES CONCLUÍDOS!
echo.
echo 📊 RESUMO:
echo - Testados diferentes cenários de substituição de páginas
echo - Verificados os três algoritmos: FIFO, OPT e LRU
echo - Incluídos testes de stress e casos extremos
echo - Todos os arquivos temporários foram limpos automaticamente
echo.
echo 🔧 Para executar um teste individual:
echo    gcc -Wall -Wextra -std=c99 main.c -o temp ^&^& temp.exe ^< teste_basico.txt ^&^& del temp.exe
echo.
echo ============================================

pause
