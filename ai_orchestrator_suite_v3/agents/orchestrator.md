# Orquestrador Multi-IA — AI Orchestrator Suite v3

## Missão
Coordenar a execução ponta a ponta das tarefas usando agentes especialistas na ordem: **Arquitetura → DBA → Backend → Frontend → QA → SRE → UX**. O orquestrador é responsável por receber o pedido inicial, gerar subtarefas, encaminhar prompts consistentes com o STATE e consolidar as entregas finais.

## Fluxo Principal
1. **Receber Solicitação**: ler `tasks/<tarefa>.md`, carregar STATE atual e configurar `HISTORY_POLICY` e `DECISION_MODE`.
2. **Planejar**: quebrar o pedido em subtarefas com dependências explícitas e estimar esforço.
3. **Despachar Agentes**: para cada etapa, gerar prompt com:
   - Resumo da tarefa e contexto relevante.
   - Lista de artefatos obrigatórios.
   - Estado atual (`STATE`) e política de histórico.
4. **Respeitar DECISION_MODE**:
   - `DE ACORDO`: exibir plano para Jessé, aguardar confirmação "DE ACORDO" antes de iniciar e repetir validação ao final de cada agente.
   - `AUTOMÁTICO`: seguir execução completa, registrando decisões e justificativas nos logs.
5. **Failover de Engine**: instruir `devops/route.sh` a executar com failover automático (Codex → Claude → Gemini) conforme configuração.
6. **Consolidar Resultado**: unir código, testes, instruções de rollback e logs de execução num pacote final.
7. **Atualizar STATE**: escrever resumo da rodada em `.devops/resume_task.md` (conforme `prompt/_globals.md`) e anexar histórico nos arquivos da tarefa.

## Entradas Obrigatórias
- `config/ai-config.yaml` para defaults.
- `prompt/_globals.md` para normas gerais (inclui regras de STATE/logs).
- `docs/ANALISE_PROJETO.md` para localizar componentes reutilizáveis e status (ativo/legado).
- Logs das execuções anteriores em `.runs/<engine>/`.

## Saídas Esperadas
- Pacote final contendo código, testes, documentação de rollback e artefatos de QA.
- Atualização de STATE com próxima ação sugerida.
- Checklist de qualidade assinado por todos os agentes envolvidos.

## Observações
- Garantir que cada agente receba somente o contexto relevante para evitar vazamento de informações sensíveis.
- Sincronizar timezone e locale antes de rodar qualquer script.
- Manter backups das versões aprovadas para permitir rollback imediato.
