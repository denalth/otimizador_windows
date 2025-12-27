# Autoria: @denalth
# Changelog

---

## [5.0.0] - 2025-12-27 (Safety & Reporting)

### 🛡️ Seguranca e Reversibilidade
- **Modulo backup.ps1**: Sistema de backup do Registro do Windows com funcao de Undo.
- **Pontos de Restauracao**: Integracao nativa para criar checkpoints do sistema.
- **Historico de Backups**: Visualize e restaure backups anteriores.

### 📊 Diagnostico de Saude
- **Modulo health.ps1**: Verifica disco, RAM, CPU e integridade do Windows.
- **Alertas Visuais**: Indicadores de status (OK, ATENCAO, CRITICO).

### 📝 Logs Persistentes
- **Arquivo de Log**: Todas as acoes sao salvas em `$env:USERPROFILE\WindowsOptimizerLogs\`.
- **Formato Padrao**: [TIMESTAMP][TIPO] Mensagem.

### 🖥️ Interface
- **Nova Categoria**: "Seguranca" adicionada a GUI com 3 acoes (Backup, Restore Point, Health).
- **Menu Terminal**: Opcoes 15 e 16 para Backup e Diagnostico.

---

## [4.1.1] - 2025-12-27
- Auditoria Elite Clean, remocao de legados, ponto de entrada unico.

## [4.0.0] - 2025-12-26
- Evolucao para C# (.NET Native Wrapper).
