# AI Orchestrator Suite v2 — Documentação

## Visão Geral
Esta pasta reúne a documentação do blueprint (`orchestrator_blueprint.md`) e do time de agentes que operam inteiramente via prompt. Não há scripts; todo o fluxo acontece dentro da CLI da engine escolhida, seguindo as instruções do blueprint e utilizando apenas os arquivos Markdown/JSON deste diretório.

## Conteúdo
- `SPEC.md`: visão funcional e técnica do orquestrador baseado em prompt.
- `ADR-0001-inicial.md`: decisão arquitetural que motivou o design atual.
- `operating-manual.md`: como disparar o blueprint, acionar agentes e manter o STATE.

## Como Navegar
1. Leia `SPEC.md` para entender etapas, métricas e guardrails.
2. Consulte o manual operacional antes de executar o blueprint com uma nova tarefa.
3. Atualize ADRs e SPEC sempre que o processo mudar.

## Contribuição
- Registre evidências no `state/resume_task.md` e nos arquivos da tarefa.
- Prefira adicionar novos agentes em `agents/` apenas se não houver reuso possível.
