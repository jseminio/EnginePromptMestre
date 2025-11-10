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
git commit -m "feat: [descr]; reuse:[X]; gates:[F1]; metrics:loc:+A/-R,rotas:+N/~M,dup:0"
git push origin [branch]
```
→ Abrir PR (qualquer plataforma) listando riscos, rollback e métricas finais.
→ Registrar resumo em `contexto.deploy`:
```
release:
  versao: "X.Y.Z"
  changelog: "..."
  branch: "..."
  comandos_git: ["git add ...", "git commit ...", "git push ..."]
  status_pr: ["aberto" | "mesclado" | "pendente"]
```
→ Confirmar com **“PUSH CONFIRMADO”** para concluir ou informar motivo para não prosseguir.
