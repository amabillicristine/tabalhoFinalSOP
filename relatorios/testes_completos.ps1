# Script PowerShell para Execução Completa de Testes do Simulador de Memória Virtual
# Executa diversos cenários de teste e compila/limpa automaticamente

Write-Host "============================================" -ForegroundColor Yellow
Write-Host "   SIMULADOR DE MEMÓRIA VIRTUAL - TESTES" -ForegroundColor Yellow
Write-Host "   Algoritmos: FIFO, OPT, LRU" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow
Write-Host ""

# Função para executar um teste
function Executar-Teste {
    param(
        [string]$nomeTest,
        [string]$arquivoEntrada,
        [string]$descricao
    )
    
    Write-Host "📋 $nomeTest" -ForegroundColor Cyan
    Write-Host "   $descricao" -ForegroundColor Gray
    Write-Host ""
    
    if (Test-Path $arquivoEntrada) {
        try {
            # Compila e executa
            $process = Start-Process -FilePath "gcc" -ArgumentList "-Wall -Wextra -std=c99 main.c -o temp_test" -NoNewWindow -Wait -PassThru
            if ($process.ExitCode -eq 0) {
                Get-Content $arquivoEntrada | & ".\temp_test.exe"
                Write-Host ""
            } else {
                Write-Host "❌ Erro na compilação do teste $nomeTest" -ForegroundColor Red
            }
        } catch {
            Write-Host "❌ Erro ao executar teste $nomeTest`: $_" -ForegroundColor Red
        } finally {
            # Limpa arquivos temporários
            if (Test-Path "temp_test.exe") { Remove-Item "temp_test.exe" -Force }
            if (Test-Path "temp_test") { Remove-Item "temp_test" -Force }
        }
    } else {
        Write-Host "❌ Arquivo de teste não encontrado: $arquivoEntrada" -ForegroundColor Red
    }
    
    Write-Host "----------------------------------------" -ForegroundColor DarkGray
    Write-Host ""
}

# Função para teste manual
function Executar-Teste-Manual {
    param(
        [string]$nomeTest,
        [string]$numFrames,
        [string]$referencias,
        [string]$descricao
    )
    
    Write-Host "📋 $nomeTest" -ForegroundColor Cyan
    Write-Host "   $descricao" -ForegroundColor Gray
    Write-Host "   Frames: $numFrames | Referências: $referencias" -ForegroundColor Gray
    Write-Host ""
    
    try {
        # Compila
        $process = Start-Process -FilePath "gcc" -ArgumentList "-Wall -Wextra -std=c99 main.c -o temp_test" -NoNewWindow -Wait -PassThru
        if ($process.ExitCode -eq 0) {
            # Cria entrada temporária
            $entrada = "$numFrames`n$($referencias -replace ' ', "`n")`n-1"
            $entrada | & ".\temp_test.exe"
            Write-Host ""
        } else {
            Write-Host "❌ Erro na compilação do teste $nomeTest" -ForegroundColor Red
        }
    } catch {
        Write-Host "❌ Erro ao executar teste $nomeTest`: $_" -ForegroundColor Red
    } finally {
        # Limpa arquivos temporários
        if (Test-Path "temp_test.exe") { Remove-Item "temp_test.exe" -Force }
        if (Test-Path "temp_test") { Remove-Item "temp_test" -Force }
    }
    
    Write-Host "----------------------------------------" -ForegroundColor DarkGray
    Write-Host ""
}

# Verifica se o arquivo main.c existe
if (-not (Test-Path "main.c")) {
    Write-Host "❌ Arquivo main.c não encontrado!" -ForegroundColor Red
    exit 1
}

Write-Host "🔧 Verificando compilador gcc..." -ForegroundColor Green
try {
    $null = Get-Command gcc -ErrorAction Stop
    Write-Host "✅ GCC encontrado e pronto para uso!" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "❌ GCC não encontrado! Instale o MinGW ou configure o PATH." -ForegroundColor Red
    exit 1
}

# TESTES BÁSICOS
Write-Host "🧪 CATEGORIA 1: TESTES BÁSICOS" -ForegroundColor Magenta
Write-Host "================================" -ForegroundColor Magenta

Executar-Teste "TESTE BÁSICO" "teste_basico.txt" "Caso padrão com 3 frames e sequência mista"

Executar-Teste-Manual "TESTE MÍNIMO" "1" "1 2 3 4 5" "Teste com apenas 1 frame (máximo stress)"

Executar-Teste "TESTE SEM PAGE FAULTS" "teste_sem_page_faults.txt" "Referências repetidas - 0 page faults esperados"

# TESTES DE VANTAGEM DE ALGORITMOS
Write-Host "🏆 CATEGORIA 2: TESTES DE VANTAGEM DOS ALGORITMOS" -ForegroundColor Magenta
Write-Host "==================================================" -ForegroundColor Magenta

Executar-Teste "VANTAGEM OPT" "teste_opt.txt" "Cenário onde OPT deve ter melhor performance"

Executar-Teste "VANTAGEM LRU" "teste_lru_vantagem.txt" "Cenário favorável ao algoritmo LRU"

# TESTES DE CASOS ESPECIAIS
Write-Host "🔬 CATEGORIA 3: CASOS ESPECIAIS E ANOMALIAS" -ForegroundColor Magenta
Write-Host "=============================================" -ForegroundColor Magenta

Executar-Teste "ANOMALIA DE BELADY" "teste_belady_anomaly.txt" "Teste para verificar anomalia de Belady no FIFO"

Executar-Teste "TESTE CÍCLICO" "teste_ciclico.txt" "Padrão de acesso cíclico às páginas"

# TESTES DE STRESS E PERFORMANCE
Write-Host "💪 CATEGORIA 4: TESTES DE STRESS" -ForegroundColor Magenta
Write-Host "=================================" -ForegroundColor Magenta

Executar-Teste "TESTE DE STRESS" "teste_stress.txt" "Alto volume de referências (40 páginas)"

Executar-Teste "NÚMEROS GRANDES" "teste_grandes_numeros.txt" "Teste com números de página elevados"

Executar-Teste "TESTE COMPLETO" "teste_completo.txt" "Cenário complexo com 10 frames"

# TESTES EXTREMOS
Write-Host "🚀 CATEGORIA 5: TESTES EXTREMOS" -ForegroundColor Magenta
Write-Host "================================" -ForegroundColor Magenta

Executar-Teste-Manual "TESTE SEQUENCIAL" "5" "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15" "Acesso sequencial puro"

Executar-Teste-Manual "TESTE REVERSO" "4" "10 9 8 7 6 5 4 3 2 1" "Acesso em ordem reversa"

Executar-Teste-Manual "TESTE PING-PONG" "2" "1 2 1 2 1 2 1 2 1 2" "Alternância entre duas páginas"

# FINALIZAÇÃO
Write-Host "✅ TODOS OS TESTES CONCLUÍDOS!" -ForegroundColor Green
Write-Host ""
Write-Host "📊 RESUMO:" -ForegroundColor Yellow
Write-Host "- Testados diferentes cenários de substituição de páginas" -ForegroundColor White
Write-Host "- Verificados os três algoritmos: FIFO, OPT e LRU" -ForegroundColor White
Write-Host "- Incluídos testes de stress e casos extremos" -ForegroundColor White
Write-Host "- Todos os arquivos temporários foram limpos automaticamente" -ForegroundColor White
Write-Host ""
Write-Host "🔧 Para executar um teste individual:" -ForegroundColor Cyan
Write-Host "   gcc -Wall -Wextra -std=c99 main.c -o temp && Get-Content teste_basico.txt | .\temp.exe && Remove-Item temp.exe" -ForegroundColor Gray
Write-Host ""
Write-Host "============================================" -ForegroundColor Yellow
