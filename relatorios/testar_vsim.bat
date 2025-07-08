@echo off
echo Testando algoritmos com arquivo vsim-gcc.txt
echo =============================================

echo.
echo Testando com 64 quadros...
main.exe 64 < vsim-gcc.txt

echo.
echo Testando com 256 quadros...
main.exe 256 < vsim-gcc.txt

echo.
echo Testando com 1024 quadros...
main.exe 1024 < vsim-gcc.txt

echo.
echo Testando com 4096 quadros...
main.exe 4096 < vsim-gcc.txt

echo.
echo Testes concluidos!
pause
