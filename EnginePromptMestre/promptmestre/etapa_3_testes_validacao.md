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
# Python + JS
pytest -v
npm run test:unit && npm run test:e2e

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

→ Confirmar com **“VALIDADO”** quando todos passarem.
→ Após receber **VALIDADO**, perguntar: **"Deseja avançar para a Etapa 4 - Deploy/Versionamento? (Sim/Não)"**
