<!-- Autoria: @denalth -->
# ROADMAP_UX_GUI.md - Plano de Evolucao para Interface Grafica Moderna

## Visao de Futuro: Windows Optimizer 3.0 (GUI Edition)

Este documento descreve o plano estrategico para evoluir o Otimizador Windows de uma ferramenta de terminal para uma **aplicacao desktop moderna com interface grafica**.

---

## Opcoes de Tecnologia

### 1. WPF (Windows Presentation Foundation) - RECOMENDADO
- **Pros**: Interface nativa Windows, visual moderno (Material Design), facil integracao com PowerShell.
- **Cons**: Apenas Windows.
- **Resultado**: Janelas com abas, checkboxes, barras de progresso, temas escuros.

### 2. Electron + React/Vue
- **Pros**: Multiplataforma, visual web moderno, comunidade vasta.
- **Cons**: Pesado (usa Chromium), mais complexo de empacotar.
- **Resultado**: App tipo Discord/VS Code.

### 3. WinUI 3 / WinForms Moderno
- **Pros**: Oficial Microsoft, integrado ao Windows 11, Fluent Design.
- **Cons**: Curva de aprendizado, requer .NET 6+.
- **Resultado**: Look and feel nativo Windows 11.

---

## Arquitetura Proposta (WPF)

```
OptimizadorGUI/
├── MainWindow.xaml          # Janela principal com menu lateral
├── Views/
│   ├── BloatwaresView.xaml  # Checklist de bloatwares
│   ├── ServicesView.xaml    # Lista de servicos com toggle
│   ├── GamingView.xaml      # Sliders e opcoes de gaming
│   ├── PrivacyView.xaml     # Switches de privacidade
│   └── SettingsView.xaml    # Configuracoes do app
├── ViewModels/               # MVVM Pattern
├── Services/
│   └── PowerShellRunner.cs  # Executa os scripts .ps1
└── App.xaml                  # Configuracao global
```

---

## Funcionalidades da GUI

| Funcionalidade | Descricao |
|----------------|-----------|
| **Perfis Salvos** | Criar e carregar perfis (Gaming, Dev, Work) com um clique. |
| **Preview de Acoes** | Antes de aplicar, mostrar exatamente o que sera feito. |
| **Barra de Progresso** | Feedback visual durante operacoes demoradas. |
| **Desfazer (Undo)** | Reverter ultima alteracao com um botao. |
| **Tema Escuro** | Visual moderno e confortavel. |
| **Notificacoes Toast** | Alertas nao-intrusivos de sucesso/erro. |
| **Auto-Update** | Verificar novas versoes automaticamente. |

---

## Exemplo de Interface (Conceitual)

```
+-----------------------------------------------------------+
|  [≡]  WINDOWS OPTIMIZER 3.0                    [_][□][X]  |
+-----------------------------------------------------------+
|                                                           |
|  [🗑️ Bloatwares]  [⚙️ Servicos]  [🎮 Gaming]  [🔒 Privacidade] |
|                                                           |
+-----------------------------------------------------------+
|                                                           |
|  ☑ Xbox App                     [ Remover Selecionados ]  |
|  ☑ Cortana                                                |
|  ☐ Maps (mantido)                                         |
|  ☑ Bing Weather                                           |
|                                                           |
|  [====================] 75% Concluido                     |
|                                                           |
+-----------------------------------------------------------+
|  [✓] Ultimo backup: 26/12/2025 03:00                      |
+-----------------------------------------------------------+
```

---

## Proximos Passos

1. **Fase 1 (Atual)**: Manter o PowerShell modular como backend.
2. **Fase 2**: Criar um wrapper WPF que chama os modulos .ps1 existentes.
3. **Fase 3**: Migrar logica critica para C# para melhor performance.
4. **Fase 4**: Publicar na Microsoft Store ou como instalador .exe.

---

## Consideracoes Finais

O codigo PowerShell atual ja esta **modular e escalavel**. A transicao para GUI sera suave porque cada modulo (.ps1) pode ser chamado como um "servico" pelo frontend grafico.

A recomendacao e: **WPF com .NET 8**, usando MVVM e temas Material Design.

