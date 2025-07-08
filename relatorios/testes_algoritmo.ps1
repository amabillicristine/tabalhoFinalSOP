# Script de Testes para Simulador de Memória Virtual
Write-Host "========================================" -ForegroundColor Green
Write-Host "BATERIA DE TESTES - SIMULADOR DE MEMORIA VIRTUAL" -ForegroundColor Green  
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Função para executar teste
function Executar-Teste($nome, $referencias, $quadros) {
    Write-Host "TESTE: $nome" -ForegroundColor Yellow
    Write-Host "Referencias: $referencias" -ForegroundColor Cyan
    Write-Host "Quadros: $quadros" -ForegroundColor Cyan
    
    try {
        # Executar teste usando stdin redirecionamento
        $resultado = $referencias -split ' ' | gcc main.c -o temp 2>$null && ($referencias -split ' ' | ForEach-Object { Write-Output $_ } | .\temp.exe $quadros) && (Remove-Item temp.exe -ErrorAction SilentlyContinue)
        Write-Host $resultado -ForegroundColor White
    } catch {
        Write-Host "Erro no teste: $_" -ForegroundColor Red
    }
    Write-Host ""
}

# Teste 1: Padrão básico
Executar-Teste "Padrao basico" "1 2 3 4 1 2 5 1 2 3 4 5" 3

# Teste 2: Sem page faults  
Executar-Teste "Sem page faults" "1 1 1 1 1" 1

# Teste 3: Padrão cíclico
Executar-Teste "Padrao ciclico" "1 2 3 1 2 3" 2

# Teste 4: Comparação diferentes números de quadros
Write-Host "TESTE: Comparacao com diferentes quadros" -ForegroundColor Yellow
$padrao = "1 2 3 4 1 2 5 1 2 3 4 5"

Write-Host "Padrao: $padrao" -ForegroundColor Cyan
Write-Host ""

foreach ($q in @(2, 3, 4)) {
    Write-Host "--- $q quadros ---" -ForegroundColor Magenta
    try {
        gcc main.c -o temp
        $resultado = $padrao -split ' ' | ForEach-Object { Write-Output $_ } | .\temp.exe $q
        Write-Host $resultado -ForegroundColor White
        Remove-Item temp.exe -ErrorAction SilentlyContinue
    } catch {
        Write-Host "Erro: $_" -ForegroundColor Red
    }
    Write-Host ""
}

# Teste 5: Casos extremos
Write-Host "TESTE: Casos extremos" -ForegroundColor Yellow

Write-Host "Muitos quadros, poucas paginas (1,2,3 com 10 quadros):" -ForegroundColor Cyan
try {
    gcc main.c -o temp
    $resultado = "1", "2", "3" | .\temp.exe 10
    Write-Host $resultado -ForegroundColor White
    Remove-Item temp.exe -ErrorAction SilentlyContinue
} catch {
    Write-Host "Erro: $_" -ForegroundColor Red
}
Write-Host ""

Write-Host "Poucos quadros, muitas paginas (1-15 com 2 quadros):" -ForegroundColor Cyan
try {
    gcc main.c -o temp
    $refs = 1..15 | ForEach-Object { "$_" }
    $resultado = $refs | .\temp.exe 2
    Write-Host $resultado -ForegroundColor White
    Remove-Item temp.exe -ErrorAction SilentlyContinue
} catch {
    Write-Host "Erro: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "TESTES CONCLUIDOS" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
