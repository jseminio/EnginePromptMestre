# Backlog de Tarefas — AI Orchestrator Suite v2

Cada tarefa deve seguir o formato abaixo para garantir rastreabilidade e retomada precisa.

```
# <ID_DA_TAREFA> — <Título>

## Contexto
- Descreva o problema ou objetivo.

## Entregáveis
- Liste resultados esperados.

## STATE
- `tarefa_id`: <ID_DA_TAREFA>
- `commit_base`: <hash>
- `TODOs`: [itens]
- `proxima_acao`: <descrição>

## Histórico
- Utilize `.devops/resume_task.md` para registrar cada execução.
```

Armazene anexos relevantes em `docs/` e referencie-os aqui.
