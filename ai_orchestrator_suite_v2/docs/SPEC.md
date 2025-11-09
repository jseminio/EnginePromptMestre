# SPEC — AI Orchestrator Suite v2

## Objetivo
Fornecer um orquestrador de múltiplas inteligências artificiais com failover automático, suporte a execução manual (`DE ACORDO`) e autônoma (`AUTOMÁTICO`), mantendo rastreabilidade completa.

## Componentes Principais
- **Blueprint** (`orchestrator_blueprint.md`): mensagem inicial que apresenta o menu de etapas, comandos globais e regras de aprovação.
- **Agentes Especialistas** (`agents/*.md`): prompts separados por domínio (Arquitetura, DBA, Backend, Frontend, QA, SRE, UX).
- **Pasta de STATE** (`state/`): contém `resume_task.md` e snapshots JSON para manter contexto entre etapas.
- **Backlog** (`tasks/`): define formato de tarefas e histórico associado.
- **Padrões Globais** (`prompt/_globals.md`): idioma, estrutura de resposta, princípios de engenharia e políticas de decisão/histórico.

## Casos de Uso
1. **Execução Manual**: Usuário escolhe `DECISION_MODE=DE ACORDO` no menu do blueprint; o orquestrador aguarda aprovação textual antes de seguir para a próxima etapa.
2. **Execução Automática**: Em `DECISION_MODE=AUTOMÁTICO`, o blueprint prossegue sozinho, apenas registrando as decisões no `state/resume_task.md`.
3. **Retomada**: Ao reabrir a engine, o usuário reaplica o blueprint e utiliza `/context` para carregar os snapshots JSON salvos.
4. **Execução Stateless**: Com `HISTORY_POLICY=ignore`, o orquestrador limpa a pasta `state/` e reinicia o fluxo.

## Pipeline Obrigatório
- Toda sessão começa com o menu do blueprint (Etapas 0→4).
- O orquestrador resume o contexto salvo antes de iniciar a etapa solicitada.
- Para cada etapa, o orquestrador decide automaticamente quais agentes devem participar (podendo acionar vários em sequência ou repetir um agente caso surjam ajustes) e apresenta os prompts correspondentes.
- As aprovações obrigatórias (`ANALISADO`, `DE ACORDO`, `IMPLEMENTADO`, `VALIDADO`, `DEPLOYADO`) são registradas no `state/resume_task.md`.
- Em caso de pulo de etapa, o blueprint alerta o usuário e pede confirmação antes de continuar.

## Requisitos Não Funcionais
- Compatibilidade com qualquer CLI que aceite prompts extensos (Codex, Claude, Gemini).
- Respostas estruturadas seguindo `prompt/_globals.md`.
- Reuso obrigatório dos agentes existentes antes de propor novos.
- Cobertura de testes ≥ 85% reportada na Etapa 3.
- Documentação atualizada em Markdown/JSON apenas.

## Integrações
- O blueprint depende apenas do conteúdo local desta pasta (não há scripts externos).
- Logs e evidências devem ser anexados manualmente às respostas e aos arquivos de STATE.

## Métricas
- Tempo médio de execução por tarefa.
- Taxa de sucesso do failover.
- Cobertura de testes reportada pelos agentes.
