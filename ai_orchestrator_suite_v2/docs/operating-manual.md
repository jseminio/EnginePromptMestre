# Manual Operacional — AI Orchestrator Suite v2

## Pré-requisitos
- CLIs instaladas: `codex`, `claude`, `gemini` (ou wrappers equivalentes).
- Python 3.11+, Node.js 18+, Git e ferramentas de CI/CD conforme ambiente.

## Inicialização
1. Execute o bootstrap apropriado:
   - Linux/Rocky: `./bootstrap/bootstrap_ai_orchestrator.sh`
   - Windows: `powershell -ExecutionPolicy Bypass -File .\bootstrap\bootstrap_ai_orchestrator.ps1`
2. Rode `./ai_orchestrator_suite_v2/devops/ai.sh init` (ou `.\ai.ps1 init`).
3. Configure `config/ai-config.yaml` conforme necessidade.

## Execução de Tarefas
```
./ai_orchestrator_suite_v2/devops/ai.sh run orchestrator tasks/FEAT-101.md
./ai_orchestrator_suite_v2/devops/ai.sh run backend tasks/BUG-201.md --engine=claude --decision=AUTOMÁTICO
```

### Parâmetros Principais
- `--engine`: `codex`, `claude`, `gemini`, `ab`, `abc`, `auto`.
- `--history`: `strict` ou `ignore`.
- `--decision`: `DE ACORDO` ou `AUTOMÁTICO`.

## Logs e Auditoria
- Execuções gravadas em `.runs/<engine>/<timestamp>.log`.
- STATE consolidado em `.devops/resume_task.md`.
- Use `tasks/<id>.md` para acompanhar histórico por tarefa.

## Recuperação
- Para retomar, execute novamente o comando com o mesmo `tasks/<id>.md`; o wrapper carregará o STATE salvo.
- Para execução stateless, utilize `--history=ignore` ou ajuste em `config/ai-config.yaml`.

## Checklist Pós-Execução
1. Validar logs de erro.
2. Confirmar cobertura ≥ 85%.
3. Atualizar STATE com próxima ação.
4. Preparar PR com resumo, evidências e instruções de rollback.
