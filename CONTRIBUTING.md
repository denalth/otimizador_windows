# Guia de Contribuicao

Obrigado por considerar contribuir com o Windows Optimizer!

---

## Como Contribuir

1. Faca um fork deste repositorio
2. Clone seu fork localmente
3. Crie uma branch para sua feature:
   ```bash
   git checkout -b feature/nome-da-feature
   ```
4. Faca suas alteracoes seguindo os padroes abaixo
5. Teste executando o orquestrador
6. Faca commit com mensagem clara
7. Faca push e abra um Pull Request

---

## Estrutura de Modulos

Cada modulo deve seguir este padrao:

```powershell
# nome-modulo.ps1 - VERSAO SUPREMA
# Descricao breve do que o modulo faz.

function NomeModulo-Interactive {
    Log-Info "=== TITULO DO MODULO ==="

    Write-Host "O que isso faz?" -ForegroundColor Yellow
    Write-Host "Explicacao detalhada antes de cada acao." -ForegroundColor Gray

    if (Confirm-YesNo "Executar acao?") {
        Run-Safe -action { ... } -description "Descricao"
    }
}
```

---

## Padrao de Commits

| Prefixo | Uso |
|---------|-----|
| feat: | Nova funcionalidade |
| fix: | Correcao de bug |
| docs: | Documentacao |
| refactor: | Refatoracao |
| perf: | Otimizacao |
| chore: | Tarefas diversas |

---

## Codigo de Conduta

- Seja respeitoso e construtivo
- Escreva codigo limpo e comentado
- Teste localmente antes de enviar PR
- Documente alteracoes no CHANGELOG.MD
