# ===================================================================
# SCRIPT DE CONFIGURAÇÃO - ALGORITMOS DE SUBSTITUIÇÃO DE PÁGINAS
# Para PowerShell
# ===================================================================

Write-Host ""
Write-Host "====================================================================" -ForegroundColor Cyan
Write-Host "   CONFIGURADOR AUTOMÁTICO - ALGORITMOS DE SUBSTITUIÇÃO DE PÁGINAS" -ForegroundColor Cyan
Write-Host "====================================================================" -ForegroundColor Cyan
Write-Host ""

# Função para verificar comando
function Test-Command($command) {
    try {
        Get-Command $command -ErrorAction Stop | Out-Null
        return $true
    } catch {
        return $false
    }
}

# [1/5] Verificar GCC
Write-Host "[1/5] Verificando GCC..." -NoNewline
if (Test-Command "gcc") {
    Write-Host " ✅ GCC encontrado" -ForegroundColor Green
} else {
    Write-Host " ❌ GCC não encontrado!" -ForegroundColor Red
    Write-Host "    Instale MinGW-w64 ou MSYS2 primeiro" -ForegroundColor Yellow
    Write-Host "    https://www.msys2.org/" -ForegroundColor Yellow
    Read-Host "Pressione Enter para sair"
    exit 1
}

# [2/5] Verificar Python
Write-Host "[2/5] Verificando Python..." -NoNewline
if (Test-Command "python") {
    Write-Host " ✅ Python encontrado" -ForegroundColor Green
} else {
    Write-Host " ❌ Python não encontrado!" -ForegroundColor Red
    Write-Host "    Instale Python 3.7+ de https://python.org" -ForegroundColor Yellow
    Read-Host "Pressione Enter para sair"
    exit 1
}

# [3/5] Compilar programa
Write-Host "[3/5] Compilando main.c..." -NoNewline
if (Test-Path "main.c") {
    try {
        $result = Start-Process -FilePath "gcc" -ArgumentList "main.c", "-o", "main.exe" -Wait -PassThru -WindowStyle Hidden
        if ($result.ExitCode -eq 0) {
            Write-Host " ✅ main.exe compilado com sucesso" -ForegroundColor Green
        } else {
            throw "Erro na compilação"
        }
    } catch {
        Write-Host " ❌ Erro na compilação" -ForegroundColor Red
        Read-Host "Pressione Enter para sair"
        exit 1
    }
} else {
    Write-Host " ❌ main.c não encontrado!" -ForegroundColor Red
    Read-Host "Pressione Enter para sair"
    exit 1
}

# [4/5] Instalar dependências Python
Write-Host "[4/5] Instalando dependências Python..." -ForegroundColor Yellow
try {
    $packages = @("matplotlib", "pandas", "numpy", "seaborn")
    foreach ($package in $packages) {
        Write-Host "  Instalando $package..." -NoNewline
        $result = Start-Process -FilePath "pip" -ArgumentList "install", $package -Wait -PassThru -WindowStyle Hidden
        if ($result.ExitCode -eq 0) {
            Write-Host " ✅" -ForegroundColor Green
        } else {
            Write-Host " ⚠️ (pode já estar instalado)" -ForegroundColor Yellow
        }
    }
    Write-Host "✅ Dependências processadas" -ForegroundColor Green
} catch {
    Write-Host "❌ Erro na instalação das dependências" -ForegroundColor Red
    Write-Host "Execute manualmente: pip install matplotlib pandas numpy seaborn" -ForegroundColor Yellow
}

# [5/5] Criar arquivos de teste
Write-Host "[5/5] Verificando arquivos de teste..." -ForegroundColor Yellow

if (!(Test-Path "arquivo1.txt")) {
    Write-Host "  Criando arquivo1.txt de exemplo..." -NoNewline
    "1 2 3 4 1 2 5 1 2 3 4 5" | Out-File -FilePath "arquivo1.txt" -Encoding UTF8
    Write-Host " ✅" -ForegroundColor Green
}

if (!(Test-Path "arquivo2.txt")) {
    Write-Host "  Criando arquivo2.txt de exemplo..." -NoNewline
    "7 0 1 2 0 3 0 4 2 3 0 3 2 1 2 0 1 7 0 1" | Out-File -FilePath "arquivo2.txt" -Encoding UTF8
    Write-Host " ✅" -ForegroundColor Green
}

# Mostrar resultado final
Write-Host ""
Write-Host "====================================================================" -ForegroundColor Green
Write-Host "                        CONFIGURAÇÃO COMPLETA!" -ForegroundColor Green
Write-Host "====================================================================" -ForegroundColor Green
Write-Host ""

Write-Host "Para usar o simulador:" -ForegroundColor Cyan
Write-Host "  1. Teste simples:       " -NoNewline -ForegroundColor White
Write-Host ".\main.exe 4 < arquivo1.txt" -ForegroundColor Yellow
Write-Host "  2. Gerar gráficos:      " -NoNewline -ForegroundColor White
Write-Host "python gerar_graficos.py" -ForegroundColor Yellow
Write-Host "  3. Ver documentação:    " -NoNewline -ForegroundColor White
Write-Host "Get-Content README.md" -ForegroundColor Yellow
Write-Host ""

Write-Host "Arquivos disponíveis:" -ForegroundColor Cyan
Write-Host "  - main.exe                   (programa principal)" -ForegroundColor White
Write-Host "  - gerar_graficos.py          (gerador de gráficos)" -ForegroundColor White
Write-Host "  - README.md                  (manual de uso)" -ForegroundColor White
Write-Host "  - arquivo1.txt / arquivo2.txt (dados de teste)" -ForegroundColor White
Write-Host ""

Write-Host "====================================================================" -ForegroundColor Green

# Oferecer execução imediata
Write-Host ""
$choice = Read-Host "Deseja executar um teste agora? (s/N)"
if ($choice -eq "s" -or $choice -eq "S") {
    Write-Host ""
    Write-Host "Executando teste com 4 quadros usando arquivo1.txt:" -ForegroundColor Yellow
    Get-Content arquivo1.txt | .\main.exe 4
    Write-Host ""
    Write-Host "Deseja gerar gráficos agora? (s/N)" -NoNewline
    $choice2 = Read-Host
    if ($choice2 -eq "s" -or $choice2 -eq "S") {
        Write-Host "Gerando gráficos..." -ForegroundColor Yellow
        python gerar_graficos.py
    }
}

Write-Host ""
Write-Host "Configuração finalizada! 🚀" -ForegroundColor Green
Read-Host "Pressione Enter para finalizar"
