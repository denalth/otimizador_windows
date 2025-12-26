<!-- Autoria: @denalth -->
# Walkthrough: Otimizador Windows 2.1 (Fusion Royale)

Esta versao e o resultado da fusao da arquitetura modular com o **Orquestrador Mestre v5.1**.

---

## 🚀 O que ha de novo na v2.1?

### ⚡ Auto-Elevacao Inteligente
Nao precisa mais se preocupar em abrir como administrador. O script detecta e se reinicia sozinho se necessario.

### 🖱️ Launcher de Dois Cliques
Criei o arquivo `Lancar_Orquestrador.bat`. Agora voce so precisa dar dois cliques nele para comecar.

### 🎮 Gaming e Rede (Notas v5.1)
Integrei os tweaks de latencia `TcpAckFrequency` e `TCPNoDelay` no modulo de rede. Seu ping vai agradecer.

### 🧹 Limpeza Profunda Automatizada
O modulo de limpeza agora configura as `StateFlags` no registro, fazendo com que o `cleanmgr` limpe tudo de forma silenciosa e completa.

### 🗺️ Navegacao Fluida
Adicionei a opcao `[Q] Voltar ao Menu` nos principais modulos para voce ter controle total do fluxo.

---

## 🛠️ Arquivos Modificados e Criados

- `main-orquestrador.ps1`: Agora com auto-elevacao e menu polido.
- `Lancar_Orquestrador.bat`: Novo atalho de execucao.
- `modules/network.ps1`: Reforcado com tweaks de rede do Mestre v5.1.
- `modules/cleanup.ps1`: Reforcado com limpeza automatica via registro.
- `DOCS_PLANNING/`: Nova pasta contendo seus planos e checklists em `.md`.

---

## ✅ Como Testar Agora?

1. Va ate a pasta `F:\.Antigravity\Otimizador Windows\`.
2. Dê dois cliques em **`Lancar_Orquestrador.bat`**.
3. Divirta-se com a versao SUPREMA DEFINITIVA.

