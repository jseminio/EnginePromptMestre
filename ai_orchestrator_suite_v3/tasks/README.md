# Backlog de Tarefas — AI Orchestrator Suite v3

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
- Registre reusos/decisões adicionais em `docs/ANALISE_PROJETO.md` para manter o catálogo atualizado.
```

Armazene anexos relevantes em `docs/` e referencie-os aqui.
