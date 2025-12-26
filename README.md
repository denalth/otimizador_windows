# Windows Optimizer - Versao 2.1 (Fusion Royale)

Orquestrador modular em PowerShell para otimizar Windows 11.
Versao definitiva que integra a arquitetura modular com o Orquestrador Mestre v5.1.

---

## Funcionalidades Principais

### Otimizacao e Performance
- Remove Bloatwares com explicacao detalhada de cada app.
- Gerencia Servicos mostrando status, descricao e risco.
- Ativa plano Ultimate Performance.
- Gaming Boost: Game Mode, HAGS, tweaks de latencia.
- Limpeza Profunda automatizada via CleanMgr.

### Desenvolvimento
- Instalacao rapida de DevTools e SDKs via winget.
- Configuracao automatizada do WSL2.

### Seguranca e Facilidade
- Auto-Elevacao: Solicita Admin automaticamente.
- Lancador .bat: Dois cliques para iniciar.
- Backup: Criacao de Ponto de Restauracao.
- Logs: Todas as acoes documentadas.

---

## Como Usar

1. De dois cliques em `Lancar_Orquestrador.bat`.
2. Ou via terminal: `.\main-orquestrador.ps1`

---

## Requisitos

- Windows 10 (2004+) ou Windows 11
- Privilegios de Administrador
- winget (App Installer)

---

## Estrutura do Projeto

```
Otimizador Windows/
├── main-orquestrador.ps1    # Menu principal (v2.1)
├── Lancar_Orquestrador.bat  # Launcher rapido
├── README.md                
├── CHANGELOG.MD             
├── CONTRIBUTING.md          
├── LICENSE                  
├── version.txt              # 2.1.0
├── DOCS_PLANNING/           # Artefatos de planejamento
│   ├── task.md
│   ├── implementation_plan.md
│   └── ROADMAP_UX_GUI.md
└── modules/                 # 13 modulos funcionais
```

---

## Licenca

Este projeto esta licenciado sob a Licenca MIT.
