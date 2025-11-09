# Estado Persistente do Orquestrador

Utilize esta pasta para armazenar o progresso entre etapas quando estiver executando o blueprint do `ai_orchestrator_suite_v2/orchestrator_blueprint.md`.

## Arquivos sugeridos
- `resume_task.md`: log textual das etapas concluídas, aprovações e próximas ações.
- `contexto_etapa_<n>.json`: snapshots opcionais para compartilhar com o orquestrador nas próximas etapas.

> Mantenha apenas arquivos `.md` ou `.json`. Apague ou substitua snapshots antes de iniciar uma nova tarefa para evitar contexto obsoleto.
