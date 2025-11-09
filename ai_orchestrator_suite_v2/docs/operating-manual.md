# Manual Operacional — AI Orchestrator Suite v2 (Modo Blueprint)

## Pré-requisitos
- Ter acesso a uma CLI de IA (Codex, Claude, Gemini ou equivalente) capaz de receber prompts longos.
- Abrir este repositório localmente para consultar `orchestrator_blueprint.md`, `agents/` e `state/`.
- Garantir que apenas arquivos `.md` ou `.json` sejam utilizados para registrar contexto.

## Passo a passo
1. **Início da sessão**
   - Abra a engine desejada.
   - Cole o conteúdo integral de `orchestrator_blueprint.md`.
   - Aguarde o menu inicial (etapas 0→4 + comandos globais).
2. **Seleção de etapa**
   - Informe o número da etapa ou um comando especial (`/status`, `/context`, `/reset`, `/help`, `/back`, `/skip [n]`).
   - Se houver contexto salvo em `state/`, traga um resumo antes de continuar.
3. **Acionamento de agentes**
   - O orquestrador avalia automaticamente quais agentes são necessários para a tarefa/etapa e apresenta os prompts na ordem correta (podendo incluir múltiplos agentes para a mesma etapa).
   - Copie cada prompt exibido em `agents/<nome>.md`, personalize com o contexto e continue até que o orquestrador confirme que todos os agentes necessários responderam.
4. **Registro de aprovações**
   - Ao final de cada etapa registre em `state/resume_task.md` a aprovação correspondente (`ANALISADO`, `DE ACORDO`, `IMPLEMENTADO`, `VALIDADO`, `DEPLOYADO`), além de evidências e próximos passos.
   - Se necessário, salve snapshots em `state/contexto_etapa_<n>.json`.
5. **Encerramento**
   - Confirme via `/status` que todas as etapas foram concluídas.
   - Liste métricas de testes, diffs de código e instruções de rollback na resposta final e no `state/resume_task.md`.

## Recomendações
- **HISTORY_POLICY**: escolha entre `strict` (mantém estado) e `ignore` (limpa `state/` antes de começar).
- **DECISION_MODE**: `DE ACORDO` exige confirmações explícitas do usuário; `AUTOMÁTICO` segue direto mas registra justificativas.
- **Organização**: inicie sempre pela Etapa 0 para evitar lacunas de contexto, mesmo em solicitações simples.

## Estrutura de STATE
- `state/resume_task.md`: log cronológico com timestamp, etapa, decisão e próxima ação.
- `state/contexto_etapa_<n>.json`: informações persistidas para alimentar etapas seguintes (ex.: arquivos afetados, métricas, riscos).
- `tasks/<ID>.md`: contexto permanente da tarefa (objetivo, entregáveis, histórico).

## Recuperação
1. Se a sessão cair, reabra a engine, cole novamente o blueprint e execute `/context` para mostrar os arquivos atuais de `state/`.
2. Continue a etapa pendente após confirmar o último registro em `resume_task.md`.
3. Caso queira reiniciar, utilize `/reset` e limpe manualmente os arquivos da pasta `state/`.

## Checklist rápido
- [ ] Etapas 0→4 concluídas e aprovadas.
- [ ] `state/resume_task.md` atualizado.
- [ ] Testes e métricas documentados.
- [ ] Próxima ação (ou handoff) registrada em `tasks/<ID>.md`.
