# AI Orchestrator Suite v2 — Pacote de Blueprint e Agentes

## O que é?
Um kit 100% baseado em Markdown/JSON para executar todo o ciclo (Análise → Planejamento → Implementação → Testes → Deploy) diretamente em qualquer CLI de IA (Codex, Claude, Gemini). Basta copiar o blueprint `orchestrator_blueprint.md`, seguir o menu 0→4 e acionar os agentes especializados desta pasta. Nenhum script `.sh`/`.ps1` é necessário.

## Como usar
1. **Abrir a engine** (Codex/Claude/Gemini) e colar o conteúdo de `orchestrator_blueprint.md`.
2. **Seguir o menu** apresentado pelo blueprint: etapas 0→4 com comandos `/status`, `/context`, `/reset`, `/help`, `/back`, `/skip [n]`.
3. **Acionar agentes**: o orquestrador identifica automaticamente quais agentes são necessários para a tarefa/etapa e dispara seus prompts em sequência (ex.: Planejamento pode envolver Arquitetura + DBA; Implementação pode invocar Backend + Frontend + UX). Basta copiar o prompt apresentado e adaptá-lo com o contexto.
4. **Persistir contexto**: utilize os arquivos em `state/` (`resume_task.md` e `contexto_etapa_<n>.json`) para registrar avanços e aprovações (`ANALISADO`, `DE ACORDO`, `IMPLEMENTADO`, `VALIDADO`, `DEPLOYADO`).
5. **Encerrar** com checklist completo (código, testes, métricas, próximos passos) antes de fechar a sessão.

## Estrutura principal
| Pasta/Arquivo | Função |
|---------------|--------|
| `orchestrator_blueprint.md` | Texto que deve ser colado ao iniciar qualquer sessão; contém o menu, comandos e regras do orquestrador. |
| `agents/*.md` | Prompts dos agentes especializados (arquitetura, backend, frontend, QA, etc.). |
| `prompt/_globals.md` | Normas gerais de comunicação, qualidade e STATE. |
| `checks/quality_checks.md` | Portões de qualidade e checklists automáticos/manuais. |
| `docs/` | SPEC, ADRs e manual descrevendo o fluxo baseado em blueprint. |
| `tasks/` | Formato oficial para backlog (`README.md` e `TEMPLATE.md`). |
| `state/` | Local onde o orquestrador registra contexto entre etapas (`resume_task.md` + snapshots JSON). |

## Fluxo recomendado
1. **Etapa 0 – Análise**: confirme entendimento e salve `state/contexto_etapa_0.json`.
2. **Etapa 1 – Planejamento**: use `agents/architect.md` (mais DBA/UX se necessário) e aguarde `DE ACORDO`.
3. **Etapa 2 – Implementação**: invoque os agentes técnicos adequados (`backend.md`, `frontend.md`, `dba.md`, `ux.md`).
4. **Etapa 3 – Testes**: execute `agents/qa.md`, registre métricas e evidências.
5. **Etapa 4 – Deploy/SRE/UX**: finalize com `agents/sre.md` (git/release) e comunicações finais; se ainda houver itens UX, o orquestrador chama `agents/ux.md` automaticamente.

Sempre recapitule o contexto salvo antes de iniciar a próxima etapa e atualize `state/resume_task.md` com timestamp, etapa, decisão e próximos passos.

## Logs e auditoria
- **STATE textual**: `state/resume_task.md`.
- **Snapshots JSON**: `state/contexto_etapa_<n>.json` (opcional).
- **Histórico por tarefa**: `tasks/<ID>.md` com contexto, entregáveis e progresso.

## Restrições
- Mantenha apenas arquivos `.md` e `.json` dentro desta suíte.
- Não crie novos scripts sem justificativa explícita.
- Utilize sempre os agentes existentes antes de propor novos.

Para detalhes adicionais consulte `docs/README.md` e `docs/SPEC.md`.
