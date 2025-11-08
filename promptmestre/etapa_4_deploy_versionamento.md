# ETAPA 4 — DEPLOY, VERSIONAMENTO E PROPAGAÇÃO — Curto

**Objetivo**: consolidar alterações com métricas e garantir versionamento adequado. Use `contexto.validacao`,
`contexto.implementacao` e `contexto.planejamento` para montar release notes consistentes independentemente da LLM utilizada.

## 📝 CHANGELOG (template)
```
## [X.Y.Z] - DD/MM/AAAA
- Adicionado: [feature]
- Modificado: [arquivos]
- Corrigido: [bugs]
- Reuso: [APIs/funções evoluídas]
- Gates: [flags/params] (default: legacy)
- Métricas: LOC [+A/-R], Rotas [+N/~M], Duplicação 0
```

## 🔄 Git (exemplo)
```bash
git status --short
git add [arquivos do escopo]
git commit -m "🚀 [Resumo curto em portugues]"
git push origin [branch]
```
→ Abrir PR (qualquer plataforma) listando riscos, rollback e métricas finais.
   - Respeitar diretrizes: objetivo, evidências (ex.: `python manage.py test`, `npm run lint`), notas de configuração, anexos visuais e links relevantes.

→ Registrar resumo em `contexto.deploy` e atualizar sessão:
```
release:
  versao: "X.Y.Z"
  changelog: "..."
  branch: "..."
  comandos_git: ["git add ...", "git commit ...", "git push ..."]
  status_pr: ["aberto" | "mesclado" | "pendente"]
```

```bash
cat > prompt_mestre/temp/contexto_etapa_4.json <<'EOFCTX4'
{
  "etapa": 4,
  "concluida": true,
  "timestamp": "2025-11-02T18:30:00Z",
  "release": {
    "versao": "X.Y.Z",
    "changelog": "...",
    "branch": "feature/cache-relatorios",
    "comandos_git": [
      "git status --short",
      "git add ...",
      "git commit -m '🚀 Cache de relatorios protegido por flag'",
      "git push origin feature/cache-relatorios"
    ],
    "status_pr": "aberto"
  }
}
EOFCTX4

cat > prompt_mestre/temp/sessao_atual.json <<'EOFSESSAOFINAL'
{
  "etapa_atual": 4,
  "etapa_concluida": true,
  "proxima_etapa": null,
  "timestamp": "2025-11-02T18:30:00Z",
  "etapas_concluidas": [0, 1, 2, 3, 4]
}
EOFSESSAOFINAL
```

→ Confirmar com **“PUSH CONFIRMADO”** para concluir ou informar motivo para não prosseguir.
