# Repository Guidelines — Engine Prompt Mestre

> Referências oficiais: `agents/workflow.md` (fluxo 0→4) e `acoes/REGRAS_NEGOCIO_CONSOLIDADAS.md` (regras detalhadas).

---

## 1. Boot do Orquestrador
- Sempre iniciar com `cat EnginePromptMestre/agents/orchestrator.md`; ele apresenta o menu Fullstack v2.4 automaticamente.  
- Executa `cat acoes/temp/sessao_atual.json || echo "{}"` antes de qualquer pergunta e exibe comandos `/status /context /reset /help /back /skip [n]`.  
- Banner obrigatório: “🤖 Orquestrador Fullstack v2.4 — Sistema Inicializado” com stack, branch e status atual.

## 2. Contexto Persistente
- JSONs ficam em `acoes/temp/sessao_atual.json` e `acoes/temp/contexto_etapa_{0..4}.json`. Leia somente se existir; caso contrário retorne `{}`.
- Salve com `cat > arquivo <<'EOF'` e valide/backup usando `scripts/context_guard.sh --file <arquivo>` (flag `FEATURE_CONTEXT_GUARD=true`).
- ` /reset ` remove todos os JSONs e reinicia o fluxo.

## 3. Workflow & Aprovação
- Ordem obrigatória: 0→1→2→3→4. Só pule com alerta de riscos e confirmação explícita.  
- Palavras-chave: `ANALISADO`, `PLANEJADO`/`DE ACORDO`, `IMPLEMENTADO`, `VALIDADO`, `DEPLOYADO`.  
- Ao finalizar cada etapa registre STATE no contexto e responda `/status` quando solicitado.

## 4. Stack resumida
- Backend: Python 3.11, Django 5.1, Redis, APScheduler.  
- Frontend: Vue 3 + Quasar + Vite.  
- Persistência: SQLite (dev) / PostgreSQL (prod), scripts auxiliares em `scripts/`.  
- Estrutura principal: `setup/`, `gerador_conteudo/`, `app_search_google/`, `front-end/`, `acoes/`, `scripts/`, bases SQLite.

## 5. Comandos úteis
- **Backend**: `python -m venv venv && source venv/bin/activate`, `pip install -r requirements.txt`, `python manage.py migrate`, `python manage.py runserver 0.0.0.0:8000`, `python manage.py test`.  
- **Jobs**: `python manage.py start_scheduler`, `stop_scheduler`, `gerar_materias_agora`, `processar_tendencias`, `reset_gemini`, `seed_dev_data`.  
- **Banco**: `python manage.py makemigrations`, `migrate`, `createsuperuser`, `dbshell`, `pg_dump`, `psql -f`.  
- **Frontend**: `cd front-end && npm install`, `npm run dev`, `npm run build`, `npm run lint`, `npm run test`.  
- **Utilidades**: `clear_redis_cache`, `unlock_generation`, `clear_gemini_usage`, `diffsettings`.

## 6. Estilo & Qualidade
- Python: PEP8, snake_case, logging estruturado; mantenha feature flags em `UPPER_SNAKE_CASE` com default legacy.  
- Vue/JS: 2 espaços, componentes `PascalCase.vue`, stores camelCase, lint/format antes de commitar.  
- Evite duplicação (use `rg`/`jscpd`) e preserve compatibilidade retroativa.  
- Testes ≥85% de cobertura, complexidade ≤10, duplicação 0% — reporte métricas junto aos resultados.

## 7. Entregas & Comunicação
- Use sempre o formato padrão (resumo → arquivos → código → testes → checklist → STATE).  
- Commits: emoji + frase curta em PT-BR, um escopo por commit.  
- PRs/relatórios: objetivo, evidências (comando + saída), notas de configuração, anexos visuais e responsáveis claros.

