# ETAPA 0 – ANÁLISE CONTEXTUAL

**Versão**: 3.1 | **Compatibilidade**: Qualquer LLM com shell | **Objetivo**: mapear reuso, riscos e métricas antes de planejar.

> Siga rigorosamente as políticas [P1–P6](../agents/politicas.md) ao conduzir esta etapa (reuso verificado, âncoras claras, diffs/logs mínimos, economia de tokens, artefatos curtos e uso do conhecimento oficial).

---

## Checklist rápido
1. ✅ Carregar sessão (se houver): `cat acoes/temp/sessao_atual.json || echo "{}"`.
2. ✅ Coletar briefing do usuário (tarefa, stack, restrições, prioridades).
3. ✅ Executar inventário (estrutura, arquivos críticos, dependências, padrões reutilizáveis).
4. ✅ Verificar aplicações de reuso (≥80% de aderência) antes de propor algo novo; documentar fontes e justificativas.
5. ✅ Identificar riscos + mitigação e registrar métricas de base (LOC, duplicação, testes, complexidade).
5. ✅ Salvar `acoes/temp/contexto_etapa_0.json` (guardião + backup) e atualizar `sessao_atual.json` com `etapa_atual=0` + aprovação `ANALISADO` pendente.

---

## Execução enxuta
```bash
# Estrutura e arquivos
rg --files | head
rg -n "class |def " --type py

# Dependências
rg -n "redis" setup/
grep -n "DATABASES" setup/settings.py

# Componentes reutilizáveis
rg -n "Service" app_search_google/
rg -n "FEATURE_" -g'*.py'

# Métricas
cloc .
radon cc -s src/
```
Documente cada descoberta com evidências (trechos de código, comandos executados) para evitar alucinações.

---

## Template de saída (resumo obrigatório)
```markdown
===============================================================================
ETAPA 0: ANÁLISE CONTEXTUAL
===============================================================================
TAREFA: [descrição]
PROJETO: [nome, stack, ambiente]

1. ARQUIVOS/PASTAS RELEVANTES
- [path] — propósito

2. COMPONENTES REUTILIZÁVEIS
- [arquivo:linhas] — como/por que reutilizar

3. DEPENDÊNCIAS E INTEGRAÇÕES
- [serviço] — contrato/risco

4. RISCOS E MITIGAÇÃO
- [risco | severidade | impacto | plano]

5. MÉTRICAS BASE
- LOC: x | Testes: y | Duplicação: z | Complexidade: c

6. ESTIMATIVA PRELIMINAR
- Complexidade, arquivos, testes, tempo, % de reuso
===============================================================================
```

---

## Persistência (use `scripts/context_guard.sh`)
```bash
cat > acoes/temp/contexto_etapa_0.json <<'EOF'
{
  "etapa": 0,
  "concluida": true,
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "tarefa_descricao": "...",
  "projeto": {"nome": "...", "stack": "..."},
  "arquivos_identificados": [...],
  "funcoes_reuso": [...],
  "dependencias": {...},
  "riscos": [...],
  "baseline": {...},
  "estimativa": {...},
  "aprovacao": {"palavra": null}
}
EOF
```
Atualize `acoes/temp/sessao_atual.json` apontando `etapa_atual=0`, `proxima_etapa=1` e aguardando aprovação `ANALISADO`.

---

## Aprovação e próxima etapa
- Palavra esperada: **`ANALISADO`** (aceite equivalentes `OK`, `DE ACORDO`).
- Após aprovação, avance para **Etapa 1 – Planejamento** (`acoes/etapa_1_planejamento.md`).
