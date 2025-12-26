# Changelog

Todas as mudancas importantes deste projeto sao documentadas aqui.
Formato: [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/)

---

## [2.1.0] - 2025-12-26 (Fusion Royale + UX Informativa)

### Adicionado
- **UX Informativa**: Todos os modulos agora explicam o que cada acao faz ANTES de pedir confirmacao.
- **Auto-Elevacao**: O script solicita privilegios de Administrador automaticamente.
- **Lancador .bat**: Novo arquivo `Lancar_Orquestrador.bat` para execucao com dois cliques.
- **Integracao Mestre v5.1**:
  - Tweaks de rede avancados (`TcpAckFrequency`, `TCPNoDelay`) no modulo `network.ps1`.
  - Limpeza profunda automatizada via `StateFlags` no modulo `cleanup.ps1`.
- **Navegacao [Q]**: Opcao de voltar ao menu principal em todos os modulos.
- **Roadmap GUI**: Documento `ROADMAP_UX_GUI.md` com plano de evolucao para interface grafica.

### Melhorado
- **Higienizacao de UI**: Removidos acentos das strings de menu para evitar erros de visualizacao.
- **Encoding UTF-8 com BOM**: Compatibilidade total com PowerShell 5.1.
- **Banner ASCII**: Banner limpo e profissional.

### Corrigido
- Erros de sintaxe (aspas e pipes) no `main-orquestrador.ps1`.
- Problemas de path dinamico ao chamar modulos.

---

## [2.0.0] - 2025-12-26

### Adicionado
- Modulos `privacy.ps1`, `gaming.ps1`, `network.ps1`.
- Sistema de Ponto de Restauracao.
- SDKs: .NET 9, Deno, Bun, Rust, Go.

---

## [1.0.0] - 2025-12-25

### Adicionado
- Estrutura modular inicial com 10 modulos.
