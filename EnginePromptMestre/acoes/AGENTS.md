# Repository Guidelines

## Operação Inicial do Orquestrador
- Ao iniciar, mostre o menu Fullstack v2.4 com etapas 0-4, status e comandos `/status`, `/context`, `/reset`, `/help`, `/back`.
- Aguarde a escolha (0-4 ou comando) e carregue apenas os arquivos da etapa selecionada.
- Comece com o banner “🤖 Orquestrador Fullstack v2.4 — Sistema Inicializado!” citando stack e checando contexto.

## Contexto Persistente
- Estado vive em `acoes/temp/sessao_atual.json` e `contexto_etapa_{0..4}.json`; leia somente se o arquivo existir, caso contrário retorne `{}`.
- Salve JSON com `cat > ... <<'EOF'` ao finalizar cada etapa.
- Reinicie removendo `contexto_*.json` e `sessao_atual.json` com `rm -f`.

## Workflow e Aprovação
- Respeite a sequência 0→1→2→3→4 e aguarde confirmação antes de avançar.
- Palavras-chave: “ANALISADO”, “PLANEJADO”, “IMPLEMENTADO”, “VALIDADO”, “DEPLOYADO” (aceite “OK”, “DE ACORDO”).
- Reforce o progresso com `/status` ou `/context`; nunca implemente sem autorização.

## Visão Geral do Projeto
- AiNoticia gera notícias SEO com Gemini AI e front-end Quasar.
- Stack: Python 3.11, Django 5.1, Redis, APScheduler, Vue/Quasar, Vite, SQLite/PostgreSQL.
- Estrutura-chave: `setup/`, `gerador_conteudo/`, `app_search_google/`, `front-end/`, `scripts/`, `acoes/`, `db.sqlite3`, `scheduler.sqlite3`.

## Comandos Essenciais
- Backend: `python -m venv venv && source venv/bin/activate`, `pip install -r requirements.txt`, `python manage.py migrate`, `python manage.py runserver 0.0.0.0:8000`, `python manage.py start_scheduler`, `python manage.py stop_scheduler`.
- Banco e testes: `python manage.py makemigrations`, `migrate`, `createsuperuser`, `dbshell`, `python manage.py test`, `python manage.py check`.
- Customizados: `python manage.py gerar_materias_agora`, `processar_tendencias noticia 1 2`, `testar_relatorio --with-telegram`, `clear_redis_cache`, `unlock_generation`, `reset_gemini`, `clear_gemini_usage`, `seed_dev_data`, `diffsettings`.
- Front-end: `cd front-end && npm install`, `npm run dev` (`npm run local` para flag), `npm run build`, `npm run lint`, `npm run format`.

## Estilo de Código e Convenções
- Python segue PEP 8 (4 espaços, `snake_case`, `PascalCase`, logging estruturado). Use `if __name__ == "__main__":` para scripts de entrada.
- Settings e feature flags permanecem em `UPPER_SNAKE_CASE`; mantenha flags legadas como padrão.
- Vue/JS utiliza indentação de 2 espaços, componentes `PascalCase.vue`, stores camelCase; execute lint/format antes de commitar.
- Evite duplicação (verifique com jscpd quando pertinente) e preserve compatibilidade retroativa.

## Testes, Métricas e Entregas
- Nomeie arquivos `test_<feature>.py`; classes em português terminam em `Test`. Mocke integrações externas como em `gerador_conteudo/tests/test_views.py`.
- Ao concluir, reporte LOC, testes executados e branch ativo via `/status`.
- Commits: emoji + resumo curto em português (`✅ Ajusta timeout do scheduler`) e escopo único.
- PRs: objetivo, evidências (`python manage.py test`, `npm run lint`), notas de configuração, anexos visuais e links para tickets com revisores marcados.
