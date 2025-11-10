# ETAPA 4 – DEPLOY E VERSIONAMENTO

**Versão**: 3.1 | **Objetivo**: liberar o release com rollback seguro e comunicação alinhada.

---

## Checklist rápido
1. Carregar contextos 0→3 (`context_guard` ligado).  
2. Confirmar que QA aprovou (`VALIDADO`).  
3. Confirmar que itens promovidos seguem a política de reuso ≥80% (catalogar componentes evoluídos) e atualizar documentação correspondente.  
4. Preparar release (CHANGELOG, README, instruções de ativação/rollback, scripts).  
5. Executar estratégia de deploy (Feature Flag, Blue-Green, Canary) e monitorar métricas/alertas.  
6. Comunicar times/usuários (UX).  
7. Salvar `acoes/temp/contexto_etapa_4.json` com release completo e registrar palavra `DEPLOYADO` / `PUSH CONFIRMADO`.

---

## Estrutura recomendada
```markdown
ETAPA 4: DEPLOY & VERSIONAMENTO
--------------------------------------------------
RELEASE
- Versão/commit/tag/branch
- Data/hora do deploy

ESTRATÉGIA
- Tipo (Flag/Blue-Green/Canary)
- Passos executados
- Rollback testado? [Sim/Não]

OBSERVABILIDADE
- Métricas (latência, erro, throughput)
- Alertas acionados? [Sim/Não]

DOCUMENTAÇÃO/COMUNICAÇÃO
- CHANGELOG, README, runbook atualizados
- Mensagens externas (UX) enviadas

STATUS FINAL: [DEPLOYADO / ROLLBACK]
--------------------------------------------------
```

---

## Persistência
```bash
cat > acoes/temp/contexto_etapa_4.json <<'EOF'
{
  "etapa": 4,
  "concluida": true,
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "release": {...},
  "deploy": {
    "estrategia": "feature-flag",
    "ambiente": "production",
    "status": "sucesso"
  },
  "observabilidade": {...},
  "documentacao": {...},
  "rollback": {...},
  "aprovacao": {"palavra": null}
}
EOF
```

---

## Aprovação
- Palavras válidas: **`DEPLOYADO`** ou **`PUSH CONFIRMADO`**.  
- Atualize `sessao_atual.json` com `etapas_concluidas=[0,1,2,3,4]` e status `workflow_finalizado`.
