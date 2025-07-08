@echo off
echo Executando simulador sem deixar arquivos...
gcc main.c -o temp_sim.exe
if exist temp_sim.exe (
    temp_sim.exe
    del temp_sim.exe
) else (
    echo Erro na compilacao
)
echo.
echo Nenhum arquivo .exe foi deixado no diretorio.
