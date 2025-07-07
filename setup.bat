@echo off
REM ===================================================================
REM SCRIPT DE CONFIGURAÇÃO - ALGORITMOS DE SUBSTITUIÇÃO DE PÁGINAS
REM ===================================================================

echo.
echo ====================================================================
echo   CONFIGURADOR AUTOMATICO - ALGORITMOS DE SUBSTITUICAO DE PAGINAS
echo ====================================================================
echo.

REM Verificar se GCC está instalado
echo [1/5] Verificando GCC...
gcc --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ GCC nao encontrado! 
    echo    Instale MinGW-w64 ou MSYS2 primeiro
    echo    https://www.msys2.org/
    pause
    exit /b 1
) else (
    echo ✅ GCC encontrado
)

REM Verificar se Python está instalado
echo [2/5] Verificando Python...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Python nao encontrado!
    echo    Instale Python 3.7+ de https://python.org
    pause
    exit /b 1
) else (
    echo ✅ Python encontrado
)

REM Compilar o programa principal
echo [3/5] Compilando main.c...
if exist main.c (
    gcc main.c -o main.exe
    if %errorlevel% equ 0 (
        echo ✅ main.exe compilado com sucesso
    ) else (
        echo ❌ Erro na compilacao
        pause
        exit /b 1
    )
) else (
    echo ❌ main.c nao encontrado!
    pause
    exit /b 1
)

REM Instalar dependências Python
echo [4/5] Instalando dependencias Python...
pip install matplotlib pandas numpy seaborn
if %errorlevel% equ 0 (
    echo ✅ Dependencias instaladas
) else (
    echo ❌ Erro na instalacao das dependencias
    pause
    exit /b 1
)

REM Criar arquivos de teste se não existirem
echo [5/5] Verificando arquivos de teste...
if not exist arquivo1.txt (
    echo Criando arquivo1.txt de exemplo...
    echo 1 2 3 4 1 2 5 1 2 3 4 5 > arquivo1.txt
    echo ✅ arquivo1.txt criado
)

if not exist arquivo2.txt (
    echo Criando arquivo2.txt de exemplo...
    echo 7 0 1 2 0 3 0 4 2 3 0 3 2 1 2 0 1 7 0 1 > arquivo2.txt
    echo ✅ arquivo2.txt criado
)

echo.
echo ====================================================================
echo                            CONFIGURACAO COMPLETA!
echo ====================================================================
echo.
echo Para usar o simulador:
echo   1. Teste simples:           main.exe 4 ^< arquivo1.txt
echo   2. Gerar graficos:          python gerar_graficos.py
echo   3. Ver documentacao:        type README.md
echo.
echo Arquivos disponiveis:
echo   - main.exe                  ^(programa principal^)
echo   - gerar_graficos.py         ^(gerador de graficos^)
echo   - README.md                 ^(manual de uso^)
echo   - arquivo1.txt / arquivo2.txt ^(dados de teste^)
echo.
echo ====================================================================
pause
