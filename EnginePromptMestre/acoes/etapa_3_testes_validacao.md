# ETAPA 3 – TESTES E VALIDAÇÃO

**Versão**: 3.1 | **Objetivo**: comprovar qualidade antes do deploy.

---

## Checklist rápido
1. Carregar contextos 0,1,2 + validar guardião.  
2. Preparar ambiente (dependências, migrações, variáveis de teste).  
3. Executar todos os testes planejados (unit, integração, regressão, performance, segurança).  
4. Registrar métricas (cobertura ≥85%, complexidade ≤10, duplicação 0%, tempos/erros).  
5. Validar logs/dashboards com feature OFF/ON.  
6. Salvar `acoes/temp/contexto_etapa_3.json` e atualizar sessão.

---

## Template de relatório
```markdown
ETAPA 3: TESTES & MÉTRICAS
--------------------------------------------------
TESTES EXECUTADOS
- Unitários: comando → resultado
- Integração: comando → resultado
- Regressão: comando → resultado
- Performance/Segurança: comando → resultado

MÉTRICAS
- Cobertura: X%
- Complexidade média: Y
- Duplicação: Z%
- Performance: [latência, throughput]

OBSERVABILIDADE
- Logs: [ok/erros]
- Dashboards/alertas: [ok]

INCIDENTES/RISCOS
- [descrição | severidade | owner]

DECISÃO: QUALITY GATE [APROVADO/REPROVADO]
--------------------------------------------------
```

---

## Persistência
```bash
cat > acoes/temp/contexto_etapa_3.json <<'EOF'
{
  "etapa": 3,
  "concluida": true,
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "testes": {
    "unitarios": {...},
    "integracao": {...},
    "regressao": {...},
    "performance": {...},
    "seguranca": {...}
  },
  "metricas": {
    "cobertura": 0,
    "complexidade": 0,
    "duplicacao": 0,
    "performance": {...}
  },
  "observabilidade": {...},
  "quality_gate": "pendente",
  "aprovacao": {"palavra": null}
}
EOF
```

---

## Aprovação
- Palavra esperada: **`VALIDADO`**. Sem ela não há Etapa 4.  
- Se algo falhar, registrar incidentes e instruir o orquestrador a retornar à etapa 2.
