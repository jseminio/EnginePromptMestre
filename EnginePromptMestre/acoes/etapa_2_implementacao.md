# ETAPA 2 – IMPLEMENTAÇÃO

**Versão**: 3.1 | **Objetivo**: implementar o plano de forma incremental, mantendo compatibilidade e evidências reais.

---

## Checklist rápido
1. Carregar contextos 0 e 1 (`contexto_etapa_{0,1}.json`) + validar com `context_guard`.  
2. Garantir que objetivos, artefatos e flags estejam aprovados (etapa 1).  
3. Executar as 5 fases abaixo, registrando evidências e testes.  
4. Salvar `acoes/temp/contexto_etapa_2.json` (arquivos, flags, testes, métricas, rollback) e atualizar sessão.

---

## Fases obrigatórias
1. **Preparação** — criar pastas/arquivos, adicionar feature flags, ajustar configurações.  
2. **Implementação Core** — escrever código reutilizando componentes existentes, integrando com flags e logs.  
3. **Testes do novo código** — unitários, integração, smoke (ver `acoes/tests/orchestrator_smoke.md`).  
4. **Validação e evidências** — testar flag OFF (legacy) e ON (novo), capturar métricas/performance.  
5. **Documentação** — atualizar README/CHANGELOG, registrar rollback/flags.

---

## Template de saída
```markdown
ETAPA 2: IMPLEMENTAÇÃO
--------------------------------------------------
Resumo do que foi entregue

ARQUIVOS CRIADOS
- path | LOC | propósito

ARQUIVOS MODIFICADOS
- path | antes/depois | backup/rollback

FEATURE FLAGS
- FEATURE_X: default, ativação, rollback

VALIDAÇÃO
- Unitários: comando + resultado
- Integração: comando + resultado
- Manual legacy/new: evidências
- Performance: métrica base → nova

PRÓXIMA ETAPA: [3 – QA]
--------------------------------------------------
```

---

## Persistência
```bash
cat > acoes/temp/contexto_etapa_2.json <<'EOF'
{
  "etapa": 2,
  "concluida": true,
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "arquivos_criados": [...],
  "arquivos_modificados": [...],
  "backups_criados": [...],
  "feature_flags": {...},
  "testes": {...},
  "performance": {...},
  "validacao": {...},
  "rollback_disponivel": true,
  "aprovacao": {"palavra": null}
}
EOF
```

---

## Aprovação
- Palavra esperada: **`IMPLEMENTADO`**.
- O contexto deve indicar o que QA precisa testar e quais flags/métricas acompanhar.
