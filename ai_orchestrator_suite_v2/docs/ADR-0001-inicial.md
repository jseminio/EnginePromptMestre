# ADR-0001 — Escolha da Arquitetura do AI Orchestrator Suite v2

## Status
Aceita — 2024-07-01

## Contexto
Precisamos de uma solução que permita orquestrar múltiplas IAs com failover, controle de decisão humano/automático e rastreamento detalhado de STATE.

## Decisão
- Utilizar scripts shell/PowerShell para integração com as CLIs Codex, Claude e Gemini.
- Persistir STATE em arquivos versionados (`state/resume_task.md`, `tasks/<id>.md`).
- Padronizar prompts e respostas via `prompt/_globals.md`.
- Estruturar agentes especialistas por domínio para garantir segregação de responsabilidades.

## Consequências
- Facilita portabilidade entre sistemas operacionais.
- Permite retomada simples e auditável.
- Exige disciplina na atualização dos arquivos de STATE e logs.
