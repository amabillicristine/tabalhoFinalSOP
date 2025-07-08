# Script PowerShell para testar vsim-gcc.txt
Write-Host "🔍 TESTE VSIM-GCC.TXT - ALGORITMOS DE SUBSTITUIÇÃO" -ForegroundColor Cyan
Write-Host "=" * 55 -ForegroundColor Cyan
Write-Host ""

$quadros_teste = @(64, 256, 1024, 4096)
$resultados = @()

foreach ($quadros in $quadros_teste) {
    Write-Host "📊 Testando $quadros quadros..." -ForegroundColor Yellow -NoNewline
    
    try {
        # Usar Get-Content para ler arquivo e passar para o programa
        $resultado = Get-Content "vsim-gcc.txt" | .\main.exe $quadros
        
        if ($resultado) {
            Write-Host " ✅" -ForegroundColor Green
            Write-Host "   Resultado: $resultado" -ForegroundColor White
            $resultados += [PSCustomObject]@{
                Quadros = $quadros
                Resultado = $resultado
            }
        } else {
            Write-Host " ❌ Sem resultado" -ForegroundColor Red
        }
    } catch {
        Write-Host " ❌ Erro: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Write-Host ""
}

Write-Host "=" * 55 -ForegroundColor Green
Write-Host "RESUMO DOS RESULTADOS:" -ForegroundColor Green
Write-Host "=" * 55 -ForegroundColor Green

foreach ($item in $resultados) {
    Write-Host ("{0,6} quadros: {1}" -f $item.Quadros, $item.Resultado) -ForegroundColor White
}

# Salvar resultados em arquivo
$output = @"
RESULTADOS DOS TESTES COM VSIM-GCC.TXT
======================================

Arquivo analisado: vsim-gcc.txt
Data do teste: $(Get-Date -Format "dd/MM/yyyy HH:mm:ss")

RESULTADOS:
-----------

"@

foreach ($item in $resultados) {
    $output += ("{0,6} quadros: {1}`n" -f $item.Quadros, $item.Resultado)
}

$output += @"

ANÁLISE:
--------

Este arquivo contém aproximadamente 1 milhão de referências de páginas,
representando um trace real de execução de sistema.

Os testes com 64, 256, 1024 e 4096 quadros mostram como o desempenho
dos algoritmos FIFO, LRU e OPT varia com o aumento da memória disponível.

OBSERVAÇÕES ESPERADAS:
- Page faults diminuem drasticamente com mais memória
- OPT sempre tem o melhor desempenho (menor número de page faults)
- A diferença entre algoritmos diminui com mais memória disponível
- Com 4096 quadros, provavelmente haverá poucos page faults

"@

$output | Out-File -FilePath "resultados_vsim_detalhado.txt" -Encoding UTF8

Write-Host ""
Write-Host "💾 Resultados salvos em: resultados_vsim_detalhado.txt" -ForegroundColor Cyan
Write-Host ""
Write-Host "Para visualizar os dados:" -ForegroundColor Yellow
Write-Host "  Get-Content resultados_vsim_detalhado.txt" -ForegroundColor White
