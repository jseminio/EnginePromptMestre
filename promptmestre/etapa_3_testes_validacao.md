# ETAPA 3 — TESTES, VALIDAÇÃO E MEDIÇÕES — Curto

**Objetivo**: garantir qualidade e **provar** não-regressão, com **medições objetivas**. Consumir `contexto.implementacao`
para validar exatamente o que foi entregue e registrar resultados consolidados em `contexto.validacao`.

## ✅ Checklist mínimo
- [ ] Arquivos criados/modificados conforme plano
- [ ] Gate default = legacy (compatibilidade preservada)
- [ ] Testes Unit/Integração/E2E executados
- [ ] Logs estruturados presentes
- [ ] **Medições coletadas e anexadas**
- [ ] Duplicação = **0** (falhar se > 0)

## 🧪 Comandos úteis
```bash
# Backend Django (principal)
python manage.py test --verbosity=2
python manage.py test gerador_conteudo.tests.test_cache_service
python manage.py check

# Front-end (se aplicavel)
if [ -d front-end ]; then
  (cd front-end && npm run test:unit && npm run test:e2e)
fi

# Scheduler/commands especificos
python manage.py start_scheduler && python manage.py stop_scheduler  # opcional, garantir que scripts novos nao quebram

# Fallback (caso manage.py nao esteja configurado)
pytest -v

# LOC tocado
git fetch origin
git diff --numstat origin/main...HEAD

# Rotas (exemplos)
rg -n "urlpatterns|path\(|re_path\(" -g "*/urls.py"
rg -n "@app\.(get|post|put|patch|delete)"
rg -n "@(app|.*_bp)\.route\("
rg -n "app\.(get|post|put|patch|delete)\(|router\.(get|post|put|patch|delete)\("
rg -n "createRouter\(|routes:\s*\["

# Duplicação
npx jscpd --threshold 0 --min-tokens 50 --reporters console,html --gitignore

# Complexidade (opcional)
radon cc -s -a .
npx complexity-report -f plain .
```
## 🗒️ Saída consolidada
```
✅ TESTES E VALIDAÇÃO
• Escopo testado: [lista]
• Comandos executados: [cmd → status]
• Métricas finais: LOC [+A/-R], Rotas [+N/~M], Duplicação [0]
• Riscos remanescentes / pendências: [lista]

📦 CONTEXTO PERSISTENTE → salvar como `contexto.validacao`
• testes_executados: [comando → evidência]
• metricas_finais: {loc:"+A/-R", rotas:"+N/~M", duplicacao:0}
• pendencias: [lista]
• recomendacao: ["pronto para deploy" | "ajustes necessários"]
```

### 💾 Persistência obrigatória
```bash
cat > prompt_mestre/temp/contexto_etapa_3.json <<'EOFCTX3'
{
  "etapa": 3,
  "concluida": true,
  "timestamp": "2025-11-02T18:00:00Z",
  "testes_executados": {
    "python manage.py test --verbosity=2": "passou",
    "python manage.py test gerador_conteudo.tests.test_cache_service": "passou"
  },
  "metricas_finais": {
    "loc": "+A/-R",
    "rotas": "+N/~M",
    "duplicacao": 0
  },
  "pendencias": [],
  "recomendacao": "pronto para deploy"
}
EOFCTX3

cat > prompt_mestre/temp/sessao_atual.json <<'EOFSESSAO3'
{
  "etapa_atual": 3,
  "etapa_concluida": true,
  "proxima_etapa": 4,
  "timestamp": "2025-11-02T18:00:00Z",
  "etapas_concluidas": [0, 1, 2, 3]
}
EOFSESSAO3
```

→ Confirmar com **“VALIDADO”** quando todos passarem.
→ Após receber **VALIDADO**, perguntar: **"Deseja avançar para a Etapa 4 - Deploy/Versionamento? (Sim/Não)"**
