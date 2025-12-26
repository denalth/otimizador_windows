# Plano de Refinamento e UX - Otimizador Windows 2.1

Este plano foca em evoluir a arquitetura modular atual integrando o melhor do "Orquestrador Mestre v5.1" e resolvendo a experiência do usuário (UX).

## Mudanças Propostas

### 0. Integração "Mestre v5.1" (O Pulo do Gato)
- **Auto-Elevação**: Implementar o bloco de código que reinicia o script como Admin automaticamente se o usuário esquecer de fazê-lo.
- **Tweaks de Rede**: Adicionar a configuração de `TcpAckFrequency` e `TCPNoDelay` em todas as interfaces no módulo `network.ps1`.
- **Limpeza Profunda**: Usar a lógica de `StateFlags0001` no registro para que o `cleanmgr` limpe absolutamente tudo sem intervenção manual no módulo `cleanup.ps1`.

### 1. Correção de Encoding e UI
- **UTF-8 com BOM**: Converter todos os arquivos. É o único formato que o PowerShell 5.1/ISE entende perfeitamente com caracteres especiais.
- **Sanitização**: Substituir strings como "Remoção" por "Remocao" ou remover acantos onde o terminal costuma falhar.

### 2. Fluxo de Navegação
- Todas as funções interativas (ex: `Bloatwares`, `Servicos`, `SDKs`) agora oferecerão a opção `[Q] Voltar ao Menu`.

### 3. Facilidade e Organização
- **Launcher**: Criar o `Lancar_Orquestrador.bat` usando a lógica que você encontrou (Bypass de ExecutionPolicy).
- **Documentação Local**: Copiar o Plano de Implementação e o Checklist para `F:\.Antigravity\Otimizador Windows\DOCS_PLANNING\`.

### 4. Upgrade de UX (Sugestões Supremas)
- **Atalho de Um Clique**: Criar um arquivo `EXECUTAR_COMO_ADMIN.bat` na raiz que eleva privilégios e roda o script automaticamente.
- **Sugestão de GUI**: Proposta de transição para uma interface WPF (Windows Presentation Foundation) moderna, mantendo a leveza do PowerShell.

## Verificação
- Teste de leitura no terminal PowerShell 5.1 e 7.x.
- Validação do fluxo de "Voltar ao Menu" sem erros.
