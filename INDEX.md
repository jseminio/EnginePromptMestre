# Engine Prompt Mestre v1.0 — Índice Principal

**Versão**: 1.0
**Data**: 09/11/2025
**Status**: Produção

---

## 🎯 INÍCIO RÁPIDO

**Para começar a usar:**
```bash
cat EnginePromptMestre/agents/orchestrator.md
```

O orquestrador apresentará o menu automaticamente.

---

## 📚 DOCUMENTAÇÃO

### Documentos Principais

| Documento | Descrição | Caminho |
|-----------|-----------|---------|
| **Regras de Negócio** | Documento autoritativo com TODAS as regras consolidadas | `REGRAS_NEGOCIO_CONSOLIDADAS.md` |
| **Índice de Agentes** | Guia completo dos 8 agentes | `agents/README.md` |
| **Workflow Estruturado** | Workflow 0→4 detalhado | `agents/workflow.md` |
| **Validação Completa** | Prova de 100% das regras aplicadas | `agents/VALIDACAO_COMPLETA.md` |

---

## 🤖 SUPER AGENTES

### Ordem de Execução

1. **Orquestrador** (`agents/orchestrator.md`)
   Coordena tudo, apresenta menu, despacha agentes

2. **Arquiteto** (`agents/architect.md`)
   Define arquitetura, SPEC, ADRs

3. **DBA** (`agents/dba.md`)
   Modelagem, migrações, performance

4. **Backend** (`agents/backend.md`)
   APIs, serviços, lógica de negócio

5. **Frontend** (`agents/frontend.md`)
   Componentes, SSR, SEO, acessibilidade

6. **QA** (`agents/qa.md`)
   Testes, cobertura, quality gate

7. **SRE** (`agents/sre.md`)
   Deploy, CI/CD, observabilidade

8. **UX** (`agents/ux.md`)
   Microcopy, mensagens, usabilidade

---

## 📋 WORKFLOW

### Etapas (0→4)

| Etapa | Nome | Aprovação | Tempo |
|-------|------|-----------|-------|
| 0 | Análise Contextual | `ANALISADO` | 5-15 min |
| 1 | Planejamento | `PLANEJADO` | 10-20 min |
| 2 | Implementação | `IMPLEMENTADO` | Variável |
| 3 | Testes e Validação | `VALIDADO` | Variável |
| 4 | Deploy e Versionamento | `DEPLOYADO` | Variável |

Ver detalhes em: `agents/workflow.md`

---

## 🎓 COMO USAR

### Modo Manual (Recomendado)
```json
{
  "DECISION_MODE": "DE ACORDO",
  "HISTORY_POLICY": "strict"
}
```
- Pausas para aprovação
- Máxima segurança

### Modo Automático
```json
{
  "DECISION_MODE": "AUTOMÁTICO",
  "HISTORY_POLICY": "strict"
}
```
- Execução autônoma
- Para tarefas bem definidas

---

## 🔑 COMANDOS ESPECIAIS

- `/status` - Ver progresso
- `/context` - Ver contextos salvos
- `/reset` - Limpar e reiniciar
- `/help` - Ajuda
- `/back` - Voltar ao menu
- `/skip [n]` - Pular para etapa n (com avisos)

---

## 📊 REGRAS PRINCIPAIS

### Princípios Fundacionais
✅ Workflow 0→4 completo
✅ Aprovações explícitas
✅ Feature flags + backward compatibility
✅ Reuso-primeiro obrigatório
✅ Anti-alucinação (evidências reais)
✅ SOLID, DRY, KISS

### Qualidade
✅ Cobertura ≥85%
✅ Complexidade ≤10
✅ Duplicação 0%
✅ Logs estruturados
✅ Rollback em todas etapas

Ver todas as regras em: `REGRAS_NEGOCIO_CONSOLIDADAS.md`

---

## 🏗️ ARQUITETURA

```
EnginePromptMestre/
├── INDEX.md (este arquivo)
├── REGRAS_NEGOCIO_CONSOLIDADAS.md
└── agents/
    ├── README.md
    ├── workflow.md
    ├── VALIDACAO_COMPLETA.md
    ├── orchestrator.md
    ├── architect.md
    ├── backend.md
    ├── frontend.md
    ├── dba.md
    ├── qa.md
    ├── sre.md
    └── ux.md
```

---

## ✅ VALIDAÇÃO

**Status**: 100% Completo e Validado

- ✅ 8 super agentes criados
- ✅ ~190 regras consolidadas
- ✅ Workflow estruturado e funcional
- ✅ Apenas Markdown/JSON (blueprints puros)
- ✅ Zero falhas identificadas

Ver prova completa em: `agents/VALIDACAO_COMPLETA.md`

---

## 🚀 COMPATIBILIDADE

**LLMs Suportados:**
- Claude (Code, Sonnet, Opus)
- GPT-4 / ChatGPT
- Google Gemini
- Codex
- Mistral
- Qualquer LLM que interprete Markdown

**Plataformas:**
- Windows, Linux, macOS
- Docker, CI/CD
- Qualquer ambiente

---

## 📞 SUPORTE

**Documentação:**
- Regras: `REGRAS_NEGOCIO_CONSOLIDADAS.md`
- Workflow: `agents/workflow.md`
- Validação: `agents/VALIDACAO_COMPLETA.md`

**Início Rápido:**
1. Ler: `agents/orchestrator.md`
2. Seguir menu apresentado
3. Workflow 0→4
4. Aprovações por etapa

---

**Engine Prompt Mestre v1.0** — Blueprint-Based AI Orchestration
**Consolidação**: ai_orchestrator_suite_v2 + v3 + promptmestre
**100% Regras de Negócio Aplicadas** ✅
