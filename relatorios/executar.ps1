# Script PowerShell para executar C sem deixar .exe
$tempName = "temp_" + (Get-Random)
try {
    Write-Host "Compilando e executando..." -ForegroundColor Green
    gcc main.c -o $tempName
    if (Test-Path "$tempName.exe") {
        & ".\$tempName.exe"
    } else {
        Write-Host "Erro na compilação" -ForegroundColor Red
    }
} finally {
    if (Test-Path "$tempName.exe") {
        Remove-Item "$tempName.exe" -Force
        Write-Host "`nArquivo temporário removido." -ForegroundColor Yellow
    }
}
