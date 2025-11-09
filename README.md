# EnginePromptMestre

Este repositório consolida integrações entre diferentes orquestradores e CLIs de IA.
As estruturas mínimas para desenvolvimento colaborativo, testes automatizados e
registro de sessões estão configuradas aqui para garantir consistência entre
Vibecode, Codex CLI, Claude CLI e Gemini CLI.

## Pré-requisitos
- Python 3.11+
- Node.js 18+
- Make 4+

## Primeiros passos
1. Clone o repositório e instale as dependências específicas do projeto principal.
2. Configure o ambiente virtual Python, se necessário, e instale dependências
   adicionais conforme a stack em uso.
3. Opcional: vincule os hooks git locais executando `git config core.hooksPath .githooks`.

## Scripts principais
Os scripts de inicialização das CLIs estão no diretório `scripts/`:
- `init_vibecode.sh`
- `init_codex.sh`
- `init_claude.sh`
- `init_gemini.sh`

Cada script prepara variáveis de ambiente padronizadas, registra a sessão e pode
ser adaptado conforme o fluxo desejado.

## Makefile
O Makefile fornece alvos para fluxos comuns:
- `make run`
- `make test`
- `make lint`
- `make format`

Adapte os comandos internos conforme serviços adicionais forem incorporados.

## Estrutura de diretórios
```
├── src/
├── tests/
├── scripts/
├── prompts/
├── docs/
└── logs/
```

## Logs e histórico
- Utilize `logs/sessao_template.md` para registrar novas sessões por CLI.
- Use `logs/bugs.md` para acompanhar incidentes e correções.
- Armazene prompts recorrentes em `prompts/biblioteca/` e versionamentos por
  issue em `prompts/<issue>.md`.

## Contribuindo
Consulte `CONTRIBUTING.md` para convenções de commits, branches e revisão de
código. Execute `make lint` e `make test` antes de abrir um Pull Request.
