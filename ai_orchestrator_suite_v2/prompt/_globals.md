# Padrões Globais — AI Orchestrator Suite v2

## Idioma
- Português (Brasil) como idioma padrão em toda comunicação, logs e documentação.

## Estrutura Obrigatória de Resposta
1. **Resumo objetivo**
2. **Arquivos criados/alterados (paths)**
3. **Código completo (sem omissões)**
4. **Testes e como rodar**
5. **Checklist de qualidade**
6. **STATE** (`tarefa_id`, `commit_base`, `TODOs`, `proxima_acao`)

## Princípios de Engenharia
- Aplicar SOLID, DRY, KISS e Clean Code.
- Listar funções e componentes reutilizáveis antes de criar novos.
- Implementar logs estruturados, mensagens amigáveis ao usuário e plano de rollback/migração.
- Manter observabilidade e segurança; nunca registrar segredos ou tokens.

## Testes e Qualidade
- Cobertura mínima de testes: 85% (`quality_gate.coverage_min`).
- Monitorar complexidade ciclomática máxima: 10 (`quality_gate.max_cyclomatic_complexity`).
- Relatar resultados de testes e métricas sempre com referência ao STATE.

## Política de Histórico (`HISTORY_POLICY`)
- `strict`: seguir histórico completo com STATE acumulado.
- `ignore`: executar em modo stateless, descartando histórico anterior.

## Modo de Decisão (`DECISION_MODE`)
- `DE ACORDO`: execução manual; o agente pausa para confirmação de Jessé antes de prosseguir.
- `AUTOMÁTICO`: execução autônoma; agente decide passos e avança até concluir.
- Todos os agentes e o orquestrador devem respeitar a flag informada.

## Entregas e Rastreamento
- Sempre finalizar com STATE consolidado, incluindo links para logs e rollback.
- Utilizar `.devops/resume_task.md` para armazenar progresso e comandos executados.
- Armazenar auditoria de execuções em `.runs/<engine>/`.

## Padrões de Observabilidade
- Logs devem ser estruturados (JSON ou chave=valor), com timestamps e contexto da tarefa.
- Garantir roteamento de erros críticos para alertas configuráveis.
- Evitar dados sensíveis em logs, mensagens e documentos compartilhados.
