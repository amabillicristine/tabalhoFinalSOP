#!/usr/bin/env python3
"""
Gerador de Gráficos para Algoritmos de Substituição de Páginas
Autor: Sistema de Análise de Performance
Data: 2025

Este script automatiza a coleta de dados e geração de gráficos
para análise dos algoritmos FIFO, LRU e OPT.
"""

import subprocess
import re
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from pathlib import Path
import sys

# Configurações visuais
plt.style.use('seaborn-v0_8')  # Estilo mais profissional
colors = {
    'fifo': '#FF6B6B',  # Vermelho
    'lru': '#4ECDC4',   # Azul-verde
    'opt': '#45B7D1'    # Azul
}

def extrair_dados(saida):
    """
    Extrai valores da saída do programa main.exe
    Formato esperado: "X quadros, Y refs: FIFO: Z PFs, LRU: W PFs, OPT: V PFs"
    """
    padrao = r'(\d+)\s+quadros,\s+(\d+)\s+refs:\s+FIFO:\s+(\d+)\s+PFs,\s+LRU:\s+(\d+)\s+PFs,\s+OPT:\s+(\d+)\s+PFs'
    match = re.search(padrao, saida.strip())
    
    if match:
        return {
            'quadros': int(match.group(1)),
            'refs': int(match.group(2)),
            'fifo': int(match.group(3)),
            'lru': int(match.group(4)),
            'opt': int(match.group(5))
        }
    else:
        print(f"ERRO: Não foi possível parsear a saída: '{saida}'")
        return None

def executar_teste(quadros, arquivo_entrada):
    """Executa um teste individual com número específico de quadros"""
    cmd = ["main.exe", str(quadros)]
    
    try:
        with open(arquivo_entrada, 'r') as f:
            conteudo = f.read()
        
        processo = subprocess.run(
            cmd, 
            input=conteudo, 
            capture_output=True, 
            text=True, 
            shell=True
        )
        
        if processo.returncode == 0:
            return extrair_dados(processo.stdout)
        else:
            print(f"ERRO na execução: {processo.stderr}")
            return None
            
    except FileNotFoundError:
        print(f"ERRO: Arquivo {arquivo_entrada} não encontrado")
        return None
    except Exception as e:
        print(f"ERRO inesperado: {e}")
        return None

def coletar_dados_completos(arquivo_entrada, quadros_teste=None):
    """Coleta dados para múltiplos números de quadros"""
    if quadros_teste is None:
        quadros_teste = [1, 2, 3, 4, 5, 6, 7]
    
    # Verificar tamanho do arquivo para estimar tempo
    try:
        with open(arquivo_entrada, 'r') as f:
            linhas = sum(1 for _ in f)
        print(f"📊 Coletando dados de {arquivo_entrada} ({linhas:,} referências)...")
        if linhas > 50000:
            print("   ⏰ Arquivo grande detectado - isso pode levar alguns minutos...")
    except:
        print(f"📊 Coletando dados de {arquivo_entrada}...")
    
    resultados = []
    total_testes = len(quadros_teste)
    
    for i, quadros in enumerate(quadros_teste, 1):
        print(f"   [{i}/{total_testes}] Testando {quadros:,} quadros...", end=" ")
        dados = executar_teste(quadros, arquivo_entrada)
        
        if dados:
            resultados.append(dados)
            print(f"✓ FIFO:{dados['fifo']:,}, LRU:{dados['lru']:,}, OPT:{dados['opt']:,}")
        else:
            print("✗ FALHOU")
    
    if not resultados:
        print("❌ Nenhum dado foi coletado!")
        return None
    
    print(f"✅ Coletados {len(resultados)} pontos de dados\n")
    return pd.DataFrame(resultados)

def criar_grafico_comparativo(df, titulo, arquivo_saida):
    """Cria gráfico de linhas comparando os três algoritmos"""
    plt.figure(figsize=(12, 8))
    
    plt.plot(df['quadros'], df['fifo'], 'o-', 
             label='FIFO', color=colors['fifo'], linewidth=3, markersize=8)
    plt.plot(df['quadros'], df['lru'], 's-', 
             label='LRU', color=colors['lru'], linewidth=3, markersize=8)
    plt.plot(df['quadros'], df['opt'], '^-', 
             label='OPT (Ótimo)', color=colors['opt'], linewidth=3, markersize=8)
    
    plt.xlabel('Número de Quadros na RAM', fontsize=14)
    plt.ylabel('Número de Page Faults', fontsize=14)
    plt.title(f'{titulo}\nComparação de Algoritmos de Substituição de Páginas', 
              fontsize=16, fontweight='bold')
    
    plt.legend(fontsize=12, loc='best')
    plt.grid(True, alpha=0.3)
    plt.xticks(df['quadros'])
    
    # Adicionar anotações nos pontos
    for i, row in df.iterrows():
        if i % 2 == 0:  # Anotar apenas alguns pontos para não poluir
            plt.annotate(f"{row['fifo']}", 
                        (row['quadros'], row['fifo']), 
                        textcoords="offset points", xytext=(0,10), ha='center',
                        fontsize=9, alpha=0.7)
    
    plt.tight_layout()
    plt.savefig(arquivo_saida, dpi=300, bbox_inches='tight')
    print(f"📈 Gráfico salvo: {arquivo_saida}")
    return plt

def criar_grafico_barras(df, titulo, arquivo_saida):
    """Cria gráfico de barras agrupadas"""
    fig, ax = plt.subplots(figsize=(14, 8))
    
    x = np.arange(len(df['quadros']))
    width = 0.25
    
    bars1 = ax.bar(x - width, df['fifo'], width, label='FIFO', 
                   color=colors['fifo'], alpha=0.8)
    bars2 = ax.bar(x, df['lru'], width, label='LRU', 
                   color=colors['lru'], alpha=0.8)
    bars3 = ax.bar(x + width, df['opt'], width, label='OPT', 
                   color=colors['opt'], alpha=0.8)
    
    ax.set_xlabel('Número de Quadros na RAM', fontsize=14)
    ax.set_ylabel('Número de Page Faults', fontsize=14)
    ax.set_title(f'{titulo}\nComparação em Barras', fontsize=16, fontweight='bold')
    ax.set_xticks(x)
    ax.set_xticklabels(df['quadros'])
    ax.legend(fontsize=12)
    
    # Adicionar valores nas barras
    def adicionar_valores(bars):
        for bar in bars:
            height = bar.get_height()
            ax.annotate(f'{int(height)}',
                       xy=(bar.get_x() + bar.get_width() / 2, height),
                       xytext=(0, 3),
                       textcoords="offset points",
                       ha='center', va='bottom', fontsize=10)
    
    adicionar_valores(bars1)
    adicionar_valores(bars2)
    adicionar_valores(bars3)
    
    plt.tight_layout()
    plt.savefig(arquivo_saida, dpi=300, bbox_inches='tight')
    print(f"📊 Gráfico de barras salvo: {arquivo_saida}")
    return plt

def criar_analise_eficiencia(df, titulo, arquivo_saida):
    """Cria gráfico de análise de eficiência"""
    fig, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2, 2, figsize=(16, 12))
    
    # 1. Redução percentual em relação ao FIFO
    reducao_lru = ((df['fifo'] - df['lru']) / df['fifo'] * 100)
    reducao_opt = ((df['fifo'] - df['opt']) / df['fifo'] * 100)
    
    ax1.plot(df['quadros'], reducao_lru, 'o-', label='LRU vs FIFO', 
             color=colors['lru'], linewidth=2, markersize=6)
    ax1.plot(df['quadros'], reducao_opt, 's-', label='OPT vs FIFO', 
             color=colors['opt'], linewidth=2, markersize=6)
    ax1.set_xlabel('Número de Quadros')
    ax1.set_ylabel('Redução (%)')
    ax1.set_title('Melhoria Percentual vs FIFO')
    ax1.legend()
    ax1.grid(True, alpha=0.3)
    
    # 2. Eficiência relativa ao ótimo
    efic_fifo = (df['opt'] / df['fifo'] * 100)
    efic_lru = (df['opt'] / df['lru'] * 100)
    
    ax2.plot(df['quadros'], efic_fifo, 'o-', label='FIFO', 
             color=colors['fifo'], linewidth=2, markersize=6)
    ax2.plot(df['quadros'], efic_lru, 's-', label='LRU', 
             color=colors['lru'], linewidth=2, markersize=6)
    ax2.axhline(y=100, color=colors['opt'], linestyle='--', 
                label='OPT (100%)', linewidth=2)
    ax2.set_xlabel('Número de Quadros')
    ax2.set_ylabel('Eficiência (%)')
    ax2.set_title('Eficiência Relativa ao Ótimo')
    ax2.legend()
    ax2.grid(True, alpha=0.3)
    
    # 3. Taxa de melhoria
    taxa_lru = df['fifo'] - df['lru']
    taxa_opt = df['fifo'] - df['opt']
    
    ax3.bar(df['quadros'] - 0.15, taxa_lru, 0.3, label='FIFO → LRU', 
            color=colors['lru'], alpha=0.7)
    ax3.bar(df['quadros'] + 0.15, taxa_opt, 0.3, label='FIFO → OPT', 
            color=colors['opt'], alpha=0.7)
    ax3.set_xlabel('Número de Quadros')
    ax3.set_ylabel('Page Faults Evitados')
    ax3.set_title('Page Faults Evitados vs FIFO')
    ax3.legend()
    
    # 4. Distribuição dos resultados
    algorithms = ['FIFO', 'LRU', 'OPT']
    means = [df['fifo'].mean(), df['lru'].mean(), df['opt'].mean()]
    stds = [df['fifo'].std(), df['lru'].std(), df['opt'].std()]
    
    bars = ax4.bar(algorithms, means, yerr=stds, capsize=5,
                   color=[colors['fifo'], colors['lru'], colors['opt']], 
                   alpha=0.7)
    ax4.set_ylabel('Page Faults (Média ± Desvio)')
    ax4.set_title('Estatísticas Resumo')
    
    # Adicionar valores nas barras
    for bar, mean in zip(bars, means):
        ax4.text(bar.get_x() + bar.get_width()/2., bar.get_height() + bar.get_height()*0.01,
                f'{mean:.1f}', ha='center', va='bottom', fontweight='bold')
    
    plt.suptitle(f'{titulo} - Análise Detalhada', fontsize=18, fontweight='bold')
    plt.tight_layout()
    plt.savefig(arquivo_saida, dpi=300, bbox_inches='tight')
    print(f"📈 Análise detalhada salva: {arquivo_saida}")
    return plt

def gerar_relatorio_textual(df, titulo, arquivo_saida):
    """Gera relatório textual com estatísticas"""
    with open(arquivo_saida, 'w', encoding='utf-8') as f:
        f.write("=" * 70 + "\n")
        f.write(f"RELATÓRIO DE ANÁLISE: {titulo.upper()}\n")
        f.write("=" * 70 + "\n\n")
        
        f.write("DADOS COLETADOS:\n")
        f.write("-" * 50 + "\n")
        f.write(f"{'Quadros':<8} {'FIFO':<6} {'LRU':<6} {'OPT':<6} {'Melhoria LRU':<12} {'Melhoria OPT':<12}\n")
        f.write("-" * 50 + "\n")
        
        for _, row in df.iterrows():
            melhoria_lru = ((row['fifo'] - row['lru']) / row['fifo'] * 100)
            melhoria_opt = ((row['fifo'] - row['opt']) / row['fifo'] * 100)
            f.write(f"{row['quadros']:<8} {row['fifo']:<6} {row['lru']:<6} {row['opt']:<6} "
                   f"{melhoria_lru:<12.1f}% {melhoria_opt:<12.1f}%\n")
        
        f.write("\n" + "=" * 50 + "\n")
        f.write("ESTATÍSTICAS RESUMO:\n")
        f.write("=" * 50 + "\n")
        f.write(f"Total de referências: {df['refs'].iloc[0]}\n")
        f.write(f"Quadros testados: {df['quadros'].min()} a {df['quadros'].max()}\n\n")
        
        f.write("MÉDIAS:\n")
        f.write(f"  FIFO: {df['fifo'].mean():.1f} page faults\n")
        f.write(f"  LRU:  {df['lru'].mean():.1f} page faults\n")
        f.write(f"  OPT:  {df['opt'].mean():.1f} page faults\n\n")
        
        melhoria_media_lru = ((df['fifo'] - df['lru']) / df['fifo'] * 100).mean()
        melhoria_media_opt = ((df['fifo'] - df['opt']) / df['fifo'] * 100).mean()
        
        f.write("MELHORIAS MÉDIAS:\n")
        f.write(f"  LRU vs FIFO: {melhoria_media_lru:.1f}%\n")
        f.write(f"  OPT vs FIFO: {melhoria_media_opt:.1f}%\n")
        f.write(f"  LRU vs OPT:  {((df['lru'] - df['opt']) / df['lru'] * 100).mean():.1f}%\n\n")
        
        f.write("EFICIÊNCIA RELATIVA AO ÓTIMO:\n")
        f.write(f"  FIFO: {(df['opt'] / df['fifo'] * 100).mean():.1f}%\n")
        f.write(f"  LRU:  {(df['opt'] / df['lru'] * 100).mean():.1f}%\n")
        f.write(f"  OPT:  100.0%\n\n")
        
        f.write("OBSERVAÇÕES:\n")
        f.write("- Valores menores de page faults indicam melhor performance\n")
        f.write("- OPT é sempre ótimo (menor número possível de page faults)\n")
        f.write("- LRU geralmente supera FIFO em cenários práticos\n")
        f.write("- A diferença diminui com o aumento do número de quadros\n")
    
    print(f"📄 Relatório salvo: {arquivo_saida}")

def criar_grafico_performance_escalabilidade(df, titulo, arquivo_saida):
    """Cria gráfico específico para análise de escalabilidade com muitos quadros"""
    fig, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2, 2, figsize=(16, 12))
    
    # 1. Gráfico logarítmico da performance
    ax1.plot(df['quadros'], df['fifo'], 'o-', 
             label='FIFO', color=colors['fifo'], linewidth=3, markersize=8)
    ax1.plot(df['quadros'], df['lru'], 's-', 
             label='LRU', color=colors['lru'], linewidth=3, markersize=8)
    ax1.plot(df['quadros'], df['opt'], '^-', 
             label='OPT', color=colors['opt'], linewidth=3, markersize=8)
    
    ax1.set_xscale('log', base=2)  # Escala logarítmica base 2
    ax1.set_xlabel('Número de Quadros (escala log₂)', fontsize=12)
    ax1.set_ylabel('Page Faults', fontsize=12)
    ax1.set_title('Performance com Escala Logarítmica', fontsize=14, fontweight='bold')
    ax1.legend()
    ax1.grid(True, alpha=0.3)
    
    # Adicionar anotações com valores
    for _, row in df.iterrows():
        ax1.annotate(f"{row['fifo']}", 
                    (row['quadros'], row['fifo']), 
                    textcoords="offset points", xytext=(0,10), ha='center',
                    fontsize=9, alpha=0.8)
    
    # 2. Taxa de redução por dobramento de memória
    if len(df) > 1:
        taxa_reducao_fifo = []
        taxa_reducao_lru = []
        taxa_reducao_opt = []
        quadros_comparacao = []
        
        for i in range(1, len(df)):
            prev_idx = i - 1
            curr_idx = i
            
            # Calcular redução percentual entre quadros consecutivos
            red_fifo = ((df.iloc[prev_idx]['fifo'] - df.iloc[curr_idx]['fifo']) / 
                       df.iloc[prev_idx]['fifo'] * 100)
            red_lru = ((df.iloc[prev_idx]['lru'] - df.iloc[curr_idx]['lru']) / 
                      df.iloc[prev_idx]['lru'] * 100)
            red_opt = ((df.iloc[prev_idx]['opt'] - df.iloc[curr_idx]['opt']) / 
                      df.iloc[prev_idx]['opt'] * 100)
            
            taxa_reducao_fifo.append(red_fifo)
            taxa_reducao_lru.append(red_lru)
            taxa_reducao_opt.append(red_opt)
            quadros_comparacao.append(f"{df.iloc[prev_idx]['quadros']}→{df.iloc[curr_idx]['quadros']}")
        
        x_pos = range(len(quadros_comparacao))
        width = 0.25
        
        ax2.bar([x - width for x in x_pos], taxa_reducao_fifo, width, 
                label='FIFO', color=colors['fifo'], alpha=0.7)
        ax2.bar(x_pos, taxa_reducao_lru, width, 
                label='LRU', color=colors['lru'], alpha=0.7)
        ax2.bar([x + width for x in x_pos], taxa_reducao_opt, width, 
                label='OPT', color=colors['opt'], alpha=0.7)
        
        ax2.set_xlabel('Aumento de Memória')
        ax2.set_ylabel('Redução de Page Faults (%)')
        ax2.set_title('Benefício do Aumento de Memória')
        ax2.set_xticks(x_pos)
        ax2.set_xticklabels(quadros_comparacao, rotation=45)
        ax2.legend()
        ax2.grid(True, alpha=0.3)
    
    # 3. Eficiência de memória (page faults por quadro)
    eficiencia_fifo = df['fifo'] / df['quadros']
    eficiencia_lru = df['lru'] / df['quadros']
    eficiencia_opt = df['opt'] / df['quadros']
    
    ax3.plot(df['quadros'], eficiencia_fifo, 'o-', 
             label='FIFO', color=colors['fifo'], linewidth=2, markersize=6)
    ax3.plot(df['quadros'], eficiencia_lru, 's-', 
             label='LRU', color=colors['lru'], linewidth=2, markersize=6)
    ax3.plot(df['quadros'], eficiencia_opt, '^-', 
             label='OPT', color=colors['opt'], linewidth=2, markersize=6)
    
    ax3.set_xscale('log', base=2)
    ax3.set_xlabel('Número de Quadros (escala log₂)')
    ax3.set_ylabel('Page Faults por Quadro')
    ax3.set_title('Eficiência de Uso da Memória')
    ax3.legend()
    ax3.grid(True, alpha=0.3)
    
    # 4. Comparação absoluta com valores específicos
    algorithms = ['FIFO', 'LRU', 'OPT']
    
    # Usar cores diferentes para cada conjunto de quadros
    colors_bars = ['#FF9999', '#66B2FF', '#99FF99', '#FFCC99']
    
    x = np.arange(len(algorithms))
    width = 0.2
    
    for i, (_, row) in enumerate(df.iterrows()):
        offset = (i - len(df)/2) * width
        values = [row['fifo'], row['lru'], row['opt']]
        bars = ax4.bar(x + offset, values, width, 
                      label=f"{row['quadros']} quadros", 
                      color=colors_bars[i % len(colors_bars)], alpha=0.8)
        
        # Adicionar valores nas barras
        for bar, val in zip(bars, values):
            ax4.annotate(f'{int(val)}',
                        xy=(bar.get_x() + bar.get_width() / 2, bar.get_height()),
                        xytext=(0, 3),
                        textcoords="offset points",
                        ha='center', va='bottom', fontsize=8, rotation=90)
    
    ax4.set_xlabel('Algoritmos')
    ax4.set_ylabel('Page Faults')
    ax4.set_title('Comparação Detalhada por Número de Quadros')
    ax4.set_xticks(x)
    ax4.set_xticklabels(algorithms)
    ax4.legend(bbox_to_anchor=(1.05, 1), loc='upper left')
    
    plt.suptitle(f'{titulo} - Análise de Escalabilidade', fontsize=16, fontweight='bold')
    plt.tight_layout()
    plt.savefig(arquivo_saida, dpi=300, bbox_inches='tight')
    print(f"📈 Gráfico de escalabilidade salvo: {arquivo_saida}")
    return plt

def main():
    """Função principal - executa análise completa"""
    print("🚀 GERADOR DE GRÁFICOS - ALGORITMOS DE SUBSTITUIÇÃO DE PÁGINAS")
    print("=" * 65)
    
    # Verificar se main.exe existe
    if not Path("main.exe").exists():
        print("❌ ERRO: main.exe não encontrado!")
        print("   Compile o programa primeiro: gcc main.c -o main.exe")
        return
    
    # Arquivos de teste para analisar
    arquivos_pequenos = ["arquivo1.txt", "arquivo2.txt"]
    arquivos_grandes = ["vsim-gcc.txt"]
    
    # Configurações de teste
    quadros_pequenos = [1, 2, 3, 4, 5, 6, 7]      # Para arquivos 1 e 2
    quadros_grandes = [64, 256, 1024, 4096]        # Para vsim-gcc.txt
    
    # Análise dos arquivos pequenos
    for arquivo in arquivos_pequenos:
        if not Path(arquivo).exists():
            print(f"⚠️  Arquivo {arquivo} não encontrado, pulando...")
            continue
        
        print(f"\n📁 ANALISANDO: {arquivo}")
        print("-" * 40)
        
        # Coletar dados
        df = coletar_dados_completos(arquivo, quadros_pequenos)
        if df is None:
            continue
        
        # Nome base para arquivos de saída
        nome_base = arquivo.replace('.txt', '')
        titulo = f"Arquivo: {arquivo}"
        
        # Gerar gráficos
        criar_grafico_comparativo(df, titulo, f"{nome_base}_comparacao.png")
        criar_grafico_barras(df, titulo, f"{nome_base}_barras.png")
        criar_analise_eficiencia(df, titulo, f"{nome_base}_analise.png")
        
        # Gerar relatório
        gerar_relatorio_textual(df, titulo, f"{nome_base}_relatorio.txt")
        
        # Salvar dados em CSV
        df.to_csv(f"{nome_base}_dados.csv", index=False)
        print(f"💾 Dados salvos: {nome_base}_dados.csv")
    
    # Análise especial do arquivo vsim-gcc.txt
    for arquivo in arquivos_grandes:
        if not Path(arquivo).exists():
            print(f"⚠️  Arquivo {arquivo} não encontrado, pulando...")
            continue
        
        print(f"\n📁 ANALISANDO ARQUIVO GRANDE: {arquivo}")
        print("   (Este processo pode demorar alguns minutos...)")
        print("-" * 50)
        
        # Coletar dados com quadros grandes
        df_grande = coletar_dados_completos(arquivo, quadros_grandes)
        if df_grande is None:
            continue
        
        # Nome base para arquivos de saída
        nome_base = arquivo.replace('.txt', '')
        titulo = f"Arquivo Grande: {arquivo} ({df_grande['refs'].iloc[0]:,} referências)"
        
        # Gerar gráficos específicos para arquivo grande
        criar_grafico_comparativo(df_grande, titulo, f"{nome_base}_comparacao.png")
        criar_analise_eficiencia(df_grande, titulo, f"{nome_base}_analise.png")
        
        # Gerar relatório específico
        gerar_relatorio_textual(df_grande, titulo, f"{nome_base}_relatorio.txt")
        
        # Salvar dados em CSV
        df_grande.to_csv(f"{nome_base}_dados.csv", index=False)
        print(f"💾 Dados salvos: {nome_base}_dados.csv")
        
        # Criar gráfico especial para arquivo grande
        criar_grafico_performance_escalabilidade(df_grande, titulo, f"{nome_base}_escalabilidade.png")
    
    print("\n✅ ANÁLISE COMPLETA!")
    print("📊 Verifique os arquivos PNG gerados para visualizar os gráficos")
    print("📄 Verifique os arquivos TXT para relatórios detalhados")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n⏹️  Análise interrompida pelo usuário")
    except Exception as e:
        print(f"\n❌ ERRO INESPERADO: {e}")
        print("Verifique se todas as dependências estão instaladas:")
        print("pip install matplotlib pandas numpy")
