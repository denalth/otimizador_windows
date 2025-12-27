# Autoria: @denalth
# Changelog - Windows Optimizer

## [5.4.1] - 2025-12-27 (Fix Operacional)
### Corrigido
- **LogBox Winget**: Agora exibe o log real de download e instalacao em tempo real.
- **Erro 0x80072EE6**: Implementado reset de Proxy WinHTTP para resolver falhas de rede no Update.
- **Higienizacao**: Removidos arquivos legados e redundantes da raiz do projeto.
## [5.4.0] - 2025-12-27 (Real Validation Edition)

### Novo
- **Validacao Pos-Execucao**: Cada acao verifica se funcionou antes de logar "OK".
- **Diagnostico Expandido**: Mostra CPU, RAM, OS Build e Disco.
- **Install-WithValidation**: Instala e confirma via `winget list`.
- **Abertura Automatica**: Relatorio de energia abre no navegador.

### Corrigido
- Ações "fake" que reportavam sucesso sem executar.
- Logs vagos substituídos por mensagens detalhadas.

---

## [5.3.1] - 2025-12-27 (Portabilidade)
- Removidos caminhos absolutos (F:\...) do executável.
- Agora portátil: funciona em qualquer pasta ou drive.

## [5.3.0] - 2025-12-27 (Supreme Edition)
- 57 ações, 14 categorias, Self-Update.

## [5.2.1] - 2025-12-27
- Terminal oculto, design estável.

## [5.2.0] - 2025-12-27
- Elite Modern UI.

