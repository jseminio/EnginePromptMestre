# ETAPA 1 – PLANEJAMENTO

**Versão**: 3.1 | **Objetivo**: transformar a análise em um plano incremental reutilizável.

---

## Checklist rápido
1. Carregar `acoes/temp/contexto_etapa_0.json` (guardião ligado).  
2. Confirmar escopo/restrições com o usuário (registar mudanças).  
3. Definir objetivos mensuráveis (vínculo com análise + critério de aceite + prioridade).  
4. Traçar estratégia de entrega (fases/trilhas, dependências).  
5. Mapear artefatos (criar/modificar/ler) com justificativa de reuso.  
6. Definir reuso, eliminar duplicidades, planejar feature flags + rollback.  
7. Planejar testes/métricas (unit, integração, regressão, performance, observabilidade).  
8. Salvar `acoes/temp/contexto_etapa_1.json` + atualizar `sessao_atual.json` (`etapa_atual=1`, `proxima_etapa=2`).

---

## Estrutura sugerida
```markdown
ETAPA 1: PLANEJAMENTO
-------------------------------------------------------------------------------
OBJETIVOS
- OBJ1: [descrição] — vínculo com análise, critério, prioridade
- ...

ESTRATÉGIA DE ENTREGA
- Fase 1: [escopo, dependências]
- Fase 2: ...

ARTEFATOS
- CRIAR: [arquivo | propósito | reuso]
- MODIFICAR: ...
- REFERENCIAR: ...

REUSO / DUPLICIDADES
- Fonte → Destino | Estratégia | Testes de regressão

FEATURE FLAGS
- FEATURE_X: padrão, condição, métricas, rollback

TESTES & MÉTRICAS
- Unitários, integração, regressão, performance, observabilidade
- Metas: LOC, cobertura, tempo resposta, error rate
-------------------------------------------------------------------------------
```

> Use listas/tabelas em vez de parágrafos longos para economizar tokens.

---

## Persistência
```bash
cat > acoes/temp/contexto_etapa_1.json <<'EOF'
{
  "etapa": 1,
  "concluida": true,
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "baseado_em_etapa_0": true,
  "objetivos": [...],
  "estrategia_entrega": [...],
  "artefatos": {...},
  "reuso_map": [...],
  "duplicidades": [...],
  "gates": [...],
  "testes_planejados": {...},
  "metricas_planejadas": {...},
  "aprovacao": {"palavra": null}
}
EOF
```

---

## Aprovação
- Palavra esperada: **`PLANEJADO`** (ou `DE ACORDO`).  
- Após aprovação, liberar **Etapa 2 – Implementação** e compartilhar plano com os agentes técnicos.
