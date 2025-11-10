# ETAPA 0 - ANALISE CONTEXTUAL + ANTIALUCINACAO

**Versao**: 3.0 | **Compatibilidade**: Todos os LLMs | **Data**: 02/11/2025

**Objetivo**: Coletar contexto essencial, mapear impacto, localizar reuso, identificar duplicacoes e provar decisoes com evidencias reais do codigo.

**Tempo estimado**: 5-15 minutos

---

## CARREGAR CONTEXTO ANTERIOR (Se existir)
```bash
if [ -f prompt_mestre/temp/sessao_atual.json ]; then
  echo "Sessao anterior detectada:"
  cat prompt_mestre/temp/sessao_atual.json
  echo ""
  echo "Deseja continuar de onde parou? (s/n)"
else
  echo "Nova sessao iniciada"
fi
```

---

## ENTRADA NECESSARIA DO USUARIO

### 1. Descricao da Tarefa:
```
O que voce quer implementar/modificar?
[Resposta do usuario aqui]
```

### 2. Tipo de Projeto (Auto-detectar primeiro):

**COMANDOS DE AUTO-DETECCAO**:
```bash
echo "Detectando stack..."
[ -f "requirements.txt" ] && echo "Python (requirements.txt)"
[ -f "setup.py" ] && echo "Python Package"
[ -f "pyproject.toml" ] && echo "Python (pyproject.toml)"
[ -f "Pipfile" ] && echo "Python (Pipenv)"
[ -f "poetry.lock" ] && echo "Python (Poetry)"
grep -q "django" requirements.txt 2>/dev/null && echo "Django"
[ -f "package-lock.json" ] && echo "Node.js (npm)"
[ -f "package.json" ] && echo "Node.js (package.json)"
[ -f "pnpm-lock.yaml" ] && echo "Node.js (pnpm)"
[ -f "yarn.lock" ] && echo "Node.js (Yarn)"
grep -q "vue" package.json 2>/dev/null && echo "Vue"
grep -q "react" package.json 2>/dev/null && echo "React"
[ -f "db.sqlite3" ] && echo "SQLite"
grep -q "postgresql" requirements.txt 2>/dev/null && echo "PostgreSQL"
[ -f "pytest.ini" ] && echo "pytest"
[ -f "jest.config.js" ] && echo "Jest"
echo ""
echo "Esta deteccao esta correta? (s/n)"
```

---

## PROCESSO DE ANALISE (6 Passos)

### PASSO 1: Estrutura do Projeto

**Comando Primario**:
```bash
tree -L 2 -I '__pycache__|*.pyc|venv|node_modules|dist|build' 2>/dev/null
```

**Fallback se tree nao disponivel**:
```bash
find . -maxdepth 2 -type d | grep -v "venv\|node_modules\|__pycache__\|\.git" | sort
```

**Fallback final (manual)**:
```bash
ls -la
echo ""
echo "Por favor, descreva a estrutura principal do projeto manualmente."
```

---

### PASSO 2: Identificar Arquivos Relevantes

**Python - Opcao A (ripgrep)**:
```bash
rg -n "def |class " --type py 2>/dev/null
```

**Python - Opcao B (grep fallback)**:
```bash
grep -rn "^def \|^class " --include="*.py" . 2>/dev/null | head -20
```

**JavaScript - Opcao A**:
```bash
rg -n "function |class |const.*=>|export " --type js --type ts 2>/dev/null
```

**JavaScript - Opcao B (fallback)**:
```bash
grep -rn "function \|class \|export " --include="*.js" --include="*.ts" . 2>/dev/null | head -20
```

---

### PASSO 3: Codigo Reutilizavel

**Para cada arquivo, analisar**:
```bash
cat arquivo.py 2>/dev/null || echo "Arquivo nao encontrado"
grep -n "^def \|^class " arquivo.py 2>/dev/null
grep -n "^import \|^from " arquivo.py 2>/dev/null
```

---

### PASSO 4: Dependencias e Integracoes

**Banco de Dados**:
```bash
rg -n "class.*Model" --type py 2>/dev/null || grep -rn "class.*Model" --include="*.py" . 2>/dev/null | head -10
```

**Cache**:
```bash
rg -n "cache|redis|memcached" -i 2>/dev/null || grep -ri "cache\|redis" --include="*.py" . 2>/dev/null | head -10
```

**Jobs/Scheduler**:
```bash
sqlite3 scheduler.sqlite3 "SELECT id, name, func FROM apscheduler_jobs;" 2>/dev/null || echo "Scheduler database nao acessivel"
```

**APIs Externas**:
```bash
rg -n "requests\.|fetch\(|axios" --type py --type js 2>/dev/null || grep -rn "requests\.\|fetch(\|axios" --include="*.py" --include="*.js" . 2>/dev/null | head -10
```

---

### PASSO 5: Riscos e Conflitos

**Buscar Chamadas de Codigo a Modificar**:
```bash
rg -n "processar_dados\(" --type py 2>/dev/null || grep -rn "processar_dados(" --include="*.py" . 2>/dev/null
```

**Verificar Testes Existentes**:
```bash
find . -name "*test*.py" -o -name "*test*.js" 2>/dev/null | wc -l
rg -n "def test_|test\(|it\(" --type py --type js 2>/dev/null | wc -l
```

**Verificar Migracoes Pendentes**:
```bash
python manage.py showmigrations 2>/dev/null | grep "\[ \]" || echo "Sem migracoes pendentes ou Django nao disponivel"
```

---

### PASSO 6: Metricas de Base (Baseline)

**LOC (Linhas de Codigo)**:
```bash
wc -l arquivo1.py arquivo2.py 2>/dev/null || echo "Arquivos nao encontrados"
find . -name "*.py" -not -path "./venv/*" -not -path "./__pycache__/*" -exec wc -l {} + 2>/dev/null | tail -1
```

**Complexidade**:
```bash
radon cc -s -a . 2>/dev/null || echo "radon nao disponivel (pip install radon)"
```

**Duplicacao**:
```bash
npx jscpd --threshold 0 --gitignore 2>/dev/null || echo "jscpd nao disponivel (npm install -g jscpd)"
```

**Testes**:
```bash
find . -name "*test*.py" | wc -l
```

> 💾 **Importante**: Capture os valores de baseline diretamente no JSON de contexto (ex.: `contexto_etapa_0.json`) usando `jq` ou redirecionamento estruturado para manter as evidencias acessiveis nas etapas seguintes.

---

## TEMPLATE DE SAIDA FINAL
```
===============================================================================
ETAPA 0: ANALISE CONTEXTUAL COMPLETA
===============================================================================

TAREFA SOLICITADA:
[Descricao em 2-3 linhas]

PROJETO:
Nome: AiNoticia
Tipo: Fullstack (Django + Vue)
Stack: Python 3.11.11, Django 5.1.5, Vue 3, Quasar, SQLite3

===============================================================================
1. ARQUIVOS DIRETAMENTE ENVOLVIDOS
===============================================================================

BACKEND:
* gerador_conteudo/article_gen.py
  - Proposito: Geracao de artigos com Gemini AI
  - LOC: 245 linhas
  - Funcoes-chave: gerar_artigo(), processar_trends()

* app_search_google/cache.py
  - Proposito: Sistema de cache Redis
  - LOC: 120 linhas
  - Funcoes-chave: RedisCache.get(), RedisCache.set()

FRONTEND:
* front-end/src/pages/Reports.vue
  - Proposito: Pagina de relatorios
  - LOC: 180 linhas

CONFIGURACAO:
* setup/settings.py
  - Feature flags: FEATURE_*, CACHE_TTL

===============================================================================
2. CODIGO REUTILIZAVEL IDENTIFICADO
===============================================================================

A) app_search_google/cache.py:10-25 -> RedisCache.get(key)
   
   EVIDENCIA REAL:
   class RedisCache:
       def get(self, key: str) -> Optional[str]:
           return redis_client.get(key)
       def set(self, key: str, value: str, ttl: int = 300):
           redis_client.setex(key, ttl, value)
   
   POR QUE REUTILIZAR:
   Sistema de cache ja implementado e testado
   
   COMO EVOLUIR:
   Adicionar metodo get_or_compute(key, compute_fn, ttl)
   Mantem backward compatibility (metodos antigos continuam)

B) gerador_conteudo/article_gen.py:45-52 -> gerar_artigo()
   Similar ao exemplo acima...

===============================================================================
3. DEPENDENCIAS E INTEGRACOES
===============================================================================

BANCO DE DADOS:
* SQLite3: db.sqlite3
* Tabelas: app_search_article, gerador_trends

CACHE:
* Redis (porta 6379)
* TTL padrao: 300s

JOBS/SCHEDULER:
* APScheduler
* Jobs ativos: refresh_trends (5min), generate_articles (15min)

APIs EXTERNAS:
* Gemini AI: Geracao de conteudo (limite: 15 req/min)
* Google Trends: Busca de tendencias

ROTAS AFETADAS:
* /api/reports/ -> Pode precisar cache
* /api/articles/ -> Ja usa cache

===============================================================================
4. RISCOS E CONFLITOS
===============================================================================

RISCO 1: Breaking change em gerar_artigo()
   - Severidade: Alta
   - Impacto: 5 chamadas em scheduler e views
   - Evidencia: rg mostrou chamadas em scheduler.py:23 e views.py:45
   - Mitigacao: Feature flag FEATURE_NEW_GENERATOR=off

RISCO 2: Redis indisponivel
   - Severidade: Media
   - Impacto: Fallback para banco de dados
   - Mitigacao: Implementar fallback automatico

BACKWARD COMPATIBILITY:
* Manter assinatura original de gerar_artigo()
* Novos parametros devem ser opcionais
* Feature flags com default=False

===============================================================================
5. METRICAS DE BASE (Baseline)
===============================================================================

CODIGO ATUAL:
* LOC total projeto: 5,420 linhas
* LOC arquivos alvo: 245 linhas
* Complexidade media: 7.2 (bom)
* Duplicacao: 2.3 porcento
* Arquivos envolvidos: 3 arquivos

TESTES EXISTENTES:
* Testes relacionados: 12 testes
* Localizacao: gerador_conteudo/tests.py
* Cobertura: Nao disponivel

===============================================================================
6. ESTIMATIVA PRELIMINAR
===============================================================================

Complexidade: Media
 - Codigo existente reutilizavel: 60 porcento
 - Integracoes existentes: Redis (ok)
 - Riscos principais: 2 identificados com mitigacao

LOC Estimado: 150 linhas (mais ou menos)
 - Novos: mais 120
 - Modificados: aproximadamente 30

Arquivos:
 - Criar: 1 arquivo (cache_service.py)
 - Modificar: 3 arquivos

Testes Necessarios: 8 novos testes

Tempo Estimado: 4-6 horas
 - Desenvolvimento: 3h
 - Testes: 1.5h
 - Revisao/Deploy: 1.5h

Reuso: 60 porcento do codigo sera reutilizado

===============================================================================
```

---

## SALVAR CONTEXTO (Automatico)

Ao finalizar a analise, o assistente deve executar:
```bash
cat > prompt_mestre/temp/contexto_etapa_0.json << 'EOFCONTEXT'
{
  "etapa": 0,
  "versao": "3.0",
  "concluida": true,
  "timestamp": "2025-11-02T15:30:00Z",
  "tarefa_descricao": "Descricao da tarefa do usuario",
  "projeto": {
    "nome": "AiNoticia",
    "tipo": "Fullstack",
    "stack": {
      "backend": "Python 3.11.11, Django 5.1.5",
      "frontend": "Vue 3, Quasar",
      "banco": "SQLite3",
      "cache": "Redis"
    }
  },
  "arquivos_identificados": [],
  "funcoes_reuso": [],
  "dependencias": {},
  "riscos": [],
  "baseline": {},
  "estimativa": {}
}
EOFCONTEXT

cat > prompt_mestre/temp/sessao_atual.json << 'EOFSESSAO'
{
  "etapa_atual": 0,
  "etapa_concluida": true,
  "proxima_etapa": 1,
  "timestamp": "2025-11-02T15:30:00Z",
  "etapas_concluidas": [0]
}
EOFSESSAO

echo ""
echo "Contexto salvo em:"
echo "   - prompt_mestre/temp/contexto_etapa_0.json"
echo "   - prompt_mestre/temp/sessao_atual.json"
```

---

## VALIDACAO FINAL
```
===============================================================================
CHECKLIST DE VALIDACAO
===============================================================================

[ ] 2-3 arquivos principais identificados?
[ ] Pelo menos 1 codigo reutilizavel encontrado?
[ ] Todos riscos mapeados com mitigacoes?
[ ] Evidencias REAIS apresentadas?
[ ] Dependencias identificadas?
[ ] Baseline capturado?
[ ] Estimativa realista?
[ ] Contexto salvo em arquivo JSON?

===============================================================================

VALIDACAO FINAL:

Este entendimento esta correto e completo?

Palavras-chave aceitas:
* "ANALISADO" (principal)
* "OK", "CORRETO", "SIM", "DE ACORDO" (alternativas)

Proxima acao apos aprovacao:
-> Avancar para ETAPA 1 (Planejamento)
-> Contexto sera carregado automaticamente

===============================================================================
```

---

**Versao**: 3.0  
**Compatibilidade**: Claude, GPT-4, Mistral, Gemini, todos os LLMs  
**Proxima Etapa**: Planejamento (etapa_1_planejamento.md)  
**Contexto Salvo**: prompt_mestre/temp/contexto_etapa_0.json
