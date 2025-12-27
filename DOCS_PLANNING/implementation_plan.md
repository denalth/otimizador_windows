# Implementation Plan - Seleção Individual de Itens (Fase 5)

## Objetivo
Aprimorar a experiência do usuário permitindo a seleção granular de ferramentas de desenvolvimento, SDKs e bloatwares, em vez de instalações/remoções automáticas em lote.

---

## Propostas de Mudança

### Módulos Interativos (`devtools.ps1`, `sdks.ps1`, `bloatwares.ps1`)
- Implementar uma função de menu que lista todos os itens disponíveis com números.
- Permitir que o usuário digite os números separados por vírgula (ex: 1,3,5) ou selecione "Tudo".
- Adicionar uma etapa de explicação detalhada antes da confirmação final para cada grupo de itens selecionados.

### Padronização de UX
- Garantir que antes de qualquer ação, o script informe:
    - O que será feito.
    - Por que é recomendado (ou quais os riscos).
    - Pedir confirmação explícita.

---

## Verificação
- [ ] Testar seleção individual no módulo `devtools.ps1`.
- [ ] Testar seleção individual no módulo `sdks.ps1`.
- [ ] Testar seleção individual no módulo `bloatwares.ps1`.
- [ ] Validar se as explicações pré-execução estão claras e detalhadas.
