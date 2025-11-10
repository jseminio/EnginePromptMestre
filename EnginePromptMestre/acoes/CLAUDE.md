# Guia Rápido — Engine Prompt Mestre

> Use este arquivo como cola para qualquer LLM com shell. Mais detalhes em `agents/workflow.md` e `acoes/REGRAS_NEGOCIO_CONSOLIDADAS.md`.

---

## Estrutura de contexto
```
acoes/temp/
├── sessao_atual.json          # Estado da sessão
├── contexto_etapa_0.json      # Análise
├── contexto_etapa_1.json      # Planejamento
├── contexto_etapa_2.json      # Implementação
├── contexto_etapa_3.json      # Validação
├── contexto_etapa_4.json      # Deploy
├── context_schema.json        # Schema leve (guardião)
└── backups/                   # Snapshots automáticos
```

### Carregar / Salvar / Resetar
```bash
# Ler (retorna {} se não existir)
if [ -f acoes/temp/contexto_etapa_X.json ]; then
  cat acoes/temp/contexto_etapa_X.json
else
  echo "{}"
fi

# Salvar com validação/backup
FEATURE_CONTEXT_GUARD=true scripts/context_guard.sh --file acoes/temp/contexto_etapa_X.json --force <<<"$(cat <<'EOF'
{ ... }
EOF )"

# Reset
rm -f acoes/temp/contexto_*.json acoes/temp/sessao_atual.json acoes/temp/backups/*.json
```

---

## Workflow resumido
1. **Orquestrador** (`agents/orchestrator.md`) apresenta menu 0→4 sempre ao iniciar.  
2. Cada etapa segue o template em `acoes/etapa_[n].md` e salva o contexto correspondente.  
3. Palavra-chave obrigatória ao final de cada etapa: `ANALISADO`, `PLANEJADO/DE ACORDO`, `IMPLEMENTADO`, `VALIDADO`, `DEPLOYADO`.  
4. `/status` e `/context` devem ler os JSONs reais; `/reset` só após confirmação do usuário.  
5. `/skip n` apenas para `n = etapa_atual` ou `etapa_atual+1`, com alerta de riscos.

---

## Princípios anti-alucinação
- Sempre execute o comando e cole a saída (mesmo resumida).  
- Nunca invente arquivos; use `ls`, `rg`, `cat` para provar.  
- Prefira referenciar caminhos/linhas ao invés de copiar blocos enormes.  
- Registre todas as evidências no contexto JSON.

---

## Estrutura padrão das respostas
1. Resumo (2‑3 linhas).  
2. Arquivos criados/alterados (paths).  
3. Código completo (sem omissões).  
4. Testes + comandos executados (com saída).  
5. Checklist de qualidade.  
6. STATE atualizado (JSON + próxima ação).

---

## Comandos úteis
- Busca: `rg --files`, `rg -n "texto"`.  
- Contagem LOC: `wc -l arquivo`.  
- Git (se liberado): `git status -sb`, `git diff`.  
- Ambiente Python: `python -m venv venv && source venv/bin/activate`, `pip install -r requirements.txt`.  
- Ambiente Frontend: `cd front-end && npm install && npm run dev`.

---

## Dúvidas frequentes
- **Onde salvar novos contextos?** Sempre em `acoes/temp/` e valide com o guardião.  
- **Preciso duplicar texto entre arquivos?** Não. Referencie `agents/workflow.md` ou o template da etapa para evitar gasto de token.  
- **Como documentar reuso?** Descreva fonte (`arquivo:linhas`), estratégia (estender/compor) e testes no JSON da etapa.  
- **Como lidar com feature flags?** Use `FEATURE_*` com default `False`, descreva ON/OFF e rollback no contexto.

---

## Lembretes finais
- Idioma: Português (Brasil) em toda comunicação.  
- Tome decisões com base em evidências reais; quando em dúvida, registre a dúvida no contexto antes de prosseguir.  
- Priorize respostas curtas, com links para arquivos, para economizar tokens.

