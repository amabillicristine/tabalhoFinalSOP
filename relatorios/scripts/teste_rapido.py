#!/usr/bin/env python3
"""
Script simplificado para testar vsim-gcc.txt
"""

import subprocess
import re

def executar_teste_simples(quadros):
    """Executa teste e retorna resultado"""
    cmd = f"cmd /c \"main.exe {quadros} < vsim-gcc.txt\""
    
    try:
        resultado = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=300)
        if resultado.returncode == 0:
            return resultado.stdout.strip()
        else:
            return f"ERRO: {resultado.stderr}"
    except subprocess.TimeoutExpired:
        return "ERRO: Timeout (5 minutos)"
    except Exception as e:
        return f"ERRO: {str(e)}"

def main():
    print("🔍 TESTE RÁPIDO - VSIM-GCC.TXT")
    print("=" * 40)
    
    quadros_teste = [64, 256, 1024, 4096]
    resultados = []
    
    for quadros in quadros_teste:
        print(f"\n📊 Testando {quadros:,} quadros...")
        resultado = executar_teste_simples(quadros)
        print(f"Resultado: {resultado}")
        resultados.append((quadros, resultado))
    
    print("\n" + "=" * 50)
    print("RESUMO DOS RESULTADOS:")
    print("=" * 50)
    
    for quadros, resultado in resultados:
        print(f"{quadros:>6} quadros: {resultado}")
    
    # Salvar resultados em arquivo
    with open("resultados_vsim.txt", "w") as f:
        f.write("RESULTADOS DOS TESTES COM VSIM-GCC.TXT\n")
        f.write("=" * 40 + "\n\n")
        for quadros, resultado in resultados:
            f.write(f"{quadros:>6} quadros: {resultado}\n")
    
    print(f"\n💾 Resultados salvos em: resultados_vsim.txt")

if __name__ == "__main__":
    main()
