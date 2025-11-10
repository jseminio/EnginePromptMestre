# SPEC — AI Orchestrator Suite v3

## Objetivo
Fornecer um orquestrador de múltiplas inteligências artificiais com failover automático, suporte a execução manual (`DE ACORDO`) e autônoma (`AUTOMÁTICO`), mantendo rastreabilidade completa.

## Componentes Principais
- **Orquestrador**: coordena agentes, aplica políticas e consolida entregas.
- **Agentes Especialistas**: responsáveis por domínios específicos (Arquitetura, DBA, Backend, Frontend, QA, SRE, UX).
- **Roteador de Engines**: scripts em `devops/` que abstraem chamadas às CLIs Codex, Claude e Gemini.
- **Persistência de STATE**: arquivos em `.devops/` e `tasks/` armazenam progresso e permitem retomada.
- **Auditoria**: diretório `.runs/` agrupa logs e saídas por engine.
- **Catálogo de Reuso**: `docs/ANALISE_PROJETO.md` concentra análises, componentes existentes e status (ativo/legado/depreciado), devendo ser atualizado a cada mudança.

## Casos de Uso
1. **Execução Manual**: Jessé seleciona `DECISION_MODE=DE ACORDO`, aprova plano e cada etapa antes de prosseguir.
2. **Execução Automática**: `DECISION_MODE=AUTOMÁTICO` executa toda a pipeline sem intervenção, respeitando failover.
3. **Failover Automático**: `ENGINE=auto` tenta Codex → Claude → Gemini, registrando sucesso ou falha de cada engine.
4. **Retomada**: utilização de `.devops/resume_task.md` para continuar tarefas interrompidas.
5. **Execução Stateless**: `HISTORY_POLICY=ignore` executa sem carregar STATE anterior.

## Requisitos Não Funcionais
- Compatibilidade com Windows, Ubuntu e RockyLinux.
- Logs estruturados e seguros (sem segredos).
- Reuso obrigatório de componentes existentes.
- Testes com cobertura ≥ 85%.
- Documentação consistente e atualizada.

## Integrações
- Scripts `devops/` executam CLIs externas (`codex`, `claude`, `gemini`).
- Configuração `config/ai-config.yaml` fornece defaults para wrapper `ai.sh`/`ai.ps1`.

## Métricas
- Tempo médio de execução por tarefa.
- Taxa de sucesso do failover.
- Cobertura de testes reportada pelos agentes.
