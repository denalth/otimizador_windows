# Autoria: @denalth
# Changelog - Windows Optimizer

## [6.0.3] - 2025-12-27 (Fixed Visuals & Actions)
### Corrigido
- **Encoding UTF-8 BOM**: Resolvido o problema de caracteres quebrados (mojibake) em emojis e acentos.
- **Ações Reativadas**: Todas as 57 ações do sistema migradas para o novo padrão WPF estável.
- **Estabilidade WPF**: Removidos erros de parsing de Dispatcher e ScriptBlocks.
## [6.0.0] - 2025-12-27 (Interface WPF Premium)
### Nova Arquitetura
- **WPF Nativo**: Migração completa de WinForms para WPF via PowerShell dinâmico.
- **Design GitHub Dark**: Paleta de cores premium (#0D1117, #58A6FF, #3FB950).
- **Emojis Coloridos**: 🎨 Cada categoria e ação tem seu emoji temático.
- **Acentuação pt-BR**: Suporte completo a caracteres acentuados.
- **Animações de Hover**: Botões com feedback visual elegante.
- **601 Linhas de Código**: Interface robusta e bem estruturada.
## [5.4.2] - 2025-12-27 (Supreme Final Edition)
### Corrigido
- **Sintaxe Critica**: Corrigidos erros de parsing na funcao Install-WithValidation.
- **Log Transparente**: Winget agora exibe progresso real no LogBox.
- **Estabilidade**: GUI 100% funcional com 57 acoes validadas.
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




