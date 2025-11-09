# AI Orchestrator Suite v2 — Multi-IA com Decisão Manual/Automática

## O que é?
Uma suíte completa de orquestração para agentes de IA (Codex, Claude, Gemini) com failover automático, retomada via STATE e suporte a execução manual (`DE ACORDO`) ou autônoma (`AUTOMÁTICO`).

## Principais Recursos
- Orquestrador e agentes especialistas (Arquitetura, DBA, Backend, Frontend, QA, SRE, UX).
- Failover automático entre Codex → Claude → Gemini.
- Execução stateless (`HISTORY_POLICY=ignore`) ou com histórico controlado (`strict`).
- Bootstrap multiplataforma (Windows, Ubuntu, RockyLinux).
- Logs padronizados e rastreabilidade via `.runs/` e `.devops/resume_task.md`.

## Comandos Essenciais
```bash
# Inicializar permissões e diretórios
./ai_orchestrator_suite_v2/devops/ai.sh init

# Executar orquestrador com defaults (engine=auto, history=strict, decision=DE ACORDO)
./ai_orchestrator_suite_v2/devops/ai.sh run orchestrator tasks/FEAT-101.md

# Forçar failover completo e modo automático
env DECISION_MODE=AUTOMÁTICO ./ai_orchestrator_suite_v2/devops/ai.sh run backend tasks/BUG-202.md --engine=abc --history=strict
```

No Windows PowerShell:
```powershell
PS> .\ai_orchestrator_suite_v2\devops\ai.ps1 init
PS> .\ai_orchestrator_suite_v2\devops\ai.ps1 run orchestrator tasks\FEAT-101.md --engine=auto --decision="DE ACORDO"
```

## Estrutura de Pastas
Consulte `docs/README.md` para detalhes de cada diretório e processos relacionados.
