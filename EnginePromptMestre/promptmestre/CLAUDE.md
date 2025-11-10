# CLAUDE.md

Este arquivo fornece orientações ao Claude Code (claude.ai/code) ao trabalhar com código neste repositório.

## 🤖 MODO DE OPERAÇÃO: ORQUESTRADOR AUTOMÁTICO

**COMPORTAMENTO AO INICIAR O CLAUDE CODE**:

Quando o Claude Code iniciar neste projeto, você DEVE **AUTOMATICAMENTE**:

1. ✅ Apresentar o menu do Orquestrador Fullstack v2.4
2. ✅ Mostrar as 5 etapas disponíveis com outputs esperados
3. ✅ Listar comandos especiais disponíveis
4. ✅ Aguardar escolha do usuário (0-4 ou comando)
5. ✅ Carregar APENAS o arquivo da etapa escolhida

**NUNCA**:
- ❌ Esperar que o usuário pergunte sobre o menu
- ❌ Iniciar sem apresentar as opções
- ❌ Carregar múltiplas etapas ao mesmo tempo

---

## 💾 SISTEMA DE CONTEXTO PERSISTENTE (CRÍTICO)

### Como Funciona:

O contexto entre etapas é salvo em arquivos JSON na pasta `prompt_mestre/temp/`.

**Arquivos de Contexto**:
```
prompt_mestre/temp/
├── sessao_atual.json          # Estado da sessão
├── contexto_etapa_0.json      # Análise
├── contexto_etapa_1.json      # Planejamento
├── contexto_etapa_2.json      # Implementação
├── contexto_etapa_3.json      # Validação
└── contexto_etapa_4.json      # Deploy
```

### Comandos Padrão:

**CARREGAR CONTEXTO**:
```bash
# Verificar se arquivo existe
if [ -f prompt_mestre/temp/contexto_etapa_X.json ]; then
  cat prompt_mestre/temp/contexto_etapa_X.json
else
  echo "{}"  # Contexto vazio
fi
```

**SALVAR CONTEXTO**:
```bash
# Salvar JSON (método preferencial)
cat > prompt_mestre/temp/contexto_etapa_X.json << 'EOFCONTEXT'
{
  "etapa": X,
  "concluida": true,
  "timestamp": "2025-11-02T15:30:00Z",
  "dados": {
    ...
  }
}
EOFCONTEXT
```

**LIMPAR CONTEXTO** (novo fluxo):
```bash
rm -f prompt_mestre/temp/contexto_*.json
rm -f prompt_mestre/temp/sessao_atual.json
```

### Fluxo de Uso:

1. **Etapa N**: Ao FINALIZAR, salva `contexto_etapa_N.json`
2. **Etapa N+1**: Ao INICIAR, carrega `contexto_etapa_N.json`
3. **Validação**: Sempre verificar se arquivo existe antes de ler

---

## 📋 Template de Apresentação Inicial
```
🤖 Orquestrador Fullstack v2.4 — Sistema Inicializado!

Projeto: AiNoticia
Stack: Python 3.11.11, Django 5.1.5, Vue 3, Quasar, SQLite3/PostgreSQL

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📍 Status: Verificando contexto anterior...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Verificando contexto...]

ETAPAS DISPONÍVEIS (Recomendado: 0→1→2→3→4):

[0] 📊 Análise Contextual + Antialucinação
    └─ Output: Mapa de reuso + Evidências + Riscos
    └─ Status: [Não iniciada/Em andamento/Concluída]

[1] 📌 Planejamento (Reuso-Primeiro + Gates)
    └─ Output: Proposta + Arquivos + Testes
    └─ Status: [...]

[2] 🧱 Implementação Controlada
    └─ Output: Código + Logs + Backward compatibility
    └─ Status: [...]

[3] ✅ Testes, Validação e Métricas
    └─ Output: LOC/Rotas/Duplicação + Testes passando
    └─ Status: [...]

[4] 🚀 Deploy, Versionamento e CHANGELOG
    └─ Output: Git commit + Documentação atualizada
    └─ Status: [...]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
COMANDOS ESPECIAIS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/status    → Ver progresso e próxima etapa recomendada
/context   → Exibir contexto atual (ler arquivos temp/)
/reset     → Limpar contexto e reiniciar fluxo
/help      → Ajuda detalhada
/back      → Voltar para etapa anterior

💡 Dica: Siga ordem sequencial para melhor qualidade
💡 Contexto salvo automaticamente em prompt_mestre/temp/

Digite o número da etapa (0-4) ou comando:
```

---

## ⚠️ WORKFLOW OBRIGATÓRIO - APROVAÇÃO POR ETAPAS

**REGRA CRÍTICA**: Seguir workflow de aprovação. NUNCA implementar sem aprovação.

### Palavras-Chave Padronizadas:

| Etapa | Palavra-Chave Principal | Alternativas Aceitas |
|-------|------------------------|---------------------|
| 0 | **"ANALISADO"** | "OK", "CORRETO", "SIM", "DE ACORDO" |
| 1 | **"PLANEJADO"** | "DE ACORDO", "APROVAR", "OK" |
| 2 | **"IMPLEMENTADO"** | "FEITO", "COMPLETO", "OK" |
| 3 | **"VALIDADO"** | "APROVADO", "TESTADO", "OK" |
| 4 | **"DEPLOYADO"** | "PUSH CONFIRMADO", "PUBLICAR", "OK" |

**Regra**: Aceitar variações razoáveis. Ser flexível com sinônimos.

---

## 📋 Visão Geral do Projeto

AiNoticia é uma plataforma automatizada de geração de notícias com otimização SEO, integração com Gemini AI e layouts customizáveis.

**Stack Tecnológica:**
- Backend: Python 3.11.11, Django 5.1.5, SQLite3/PostgreSQL
- Frontend: Vue 3, Quasar Framework, Vite
- Serviços: Redis (cache), APScheduler (agendamento), Google Gemini AI
- Ambiente: Rocky Linux 9

---

## 🔧 Comandos Essenciais

### Backend (Django)

**Configuração Inicial:**
```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python manage.py migrate
```

**Desenvolvimento:**
```bash
python manage.py runserver                    # Localhost
python manage.py runserver 0.0.0.0:8000      # Rede local
python manage.py start_scheduler              # Scheduler
python manage.py stop_scheduler
```

**Banco de Dados:**
```bash
python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser
python manage.py dbshell
```

**Testes:**
```bash
python manage.py test
python manage.py test app_search_google
python manage.py test --verbosity=2
python manage.py check
```

**Comandos Customizados:**
```bash
# Geração de conteúdo
python manage.py gerar_materias_agora
python manage.py processar_tendencias noticia 1 2
python manage.py testar_relatorio --with-telegram

# Cache e estado
python manage.py clear_redis_cache
python manage.py unlock_generation

# Limites de API
python manage.py reset_gemini
python manage.py clear_gemini_usage

# Desenvolvimento
python manage.py seed_dev_data
python manage.py diffsettings
```

### Frontend (Quasar/Vue)
```bash
cd front-end
npm install
npm run dev              # localhost:9000
npm run build
npm run lint
npm run format
```

---

## 🏗️ Arquitetura

### Backend
- `setup/` - Configuração Django, settings, URLs
- `app_search_google/` - Busca, SEO, artigos, Redis
- `gerador_conteudo/` - Pipeline geração, schedulers, IA

**Arquivos Importantes:**
- `setup/settings.py` - Configuração central + feature flags
- `setup/urls.py` - Roteamento URLs
- `db.sqlite3` - Banco principal
- `scheduler.sqlite3` - Jobs APScheduler

### Frontend
- `front-end/src/api/` - Clientes API
- `front-end/src/components/` - Componentes Vue
- `front-end/src/pages/` - Páginas/views
- `front-end/src/state/` - Pinia stores

### Pipeline de Geração
1. Scheduler executa jobs periódicos
2. Processa tendências do Google Trends
3. Gera artigos com Gemini AI
4. Armazena em banco e filesystem
5. Otimiza SEO e gera sitemaps

---

## 📜 Diretrizes de Desenvolvimento

**Python:**
- PEP 8 (4 espaços)
- `snake_case` para funções/variáveis
- `PascalCase` para classes
- Logging estruturado obrigatório

**Vue/JavaScript:**
- 2 espaços (`.editorconfig`)
- `PascalCase.vue` para componentes
- `camelCase` para composables
- Executar lint e format antes de commits

### Convenções Críticas

1. **Feature Flags**: Default legacy
2. **Zero Duplicação**: Verificar com jscpd
3. **Logging**: Estruturado obrigatório
4. **Headers**: Arquivos novos
5. **Backward Compatibility**: Preservar código

---

## 🎯 Modo Orquestrador

Sistema especializado em `prompt_mestre/` com workflows por etapas:

| Arquivo | Propósito | Aprovação | Contexto |
|---------|-----------|-----------|----------|
| `etapa_0_analise.md` | Análise + Anti-alucinação | "ANALISADO" | → temp/contexto_etapa_0.json |
| `etapa_1_planejamento.md` | Planejamento + Reuso | "PLANEJADO" | → temp/contexto_etapa_1.json |
| `etapa_2_implementacao.md` | Implementação + Gates | "IMPLEMENTADO" | → temp/contexto_etapa_2.json |
| `etapa_3_testes_validacao.md` | Testes + Métricas | "VALIDADO" | → temp/contexto_etapa_3.json |
| `etapa_4_deploy_versionamento.md` | Deploy + CHANGELOG | "DEPLOYADO" | → temp/contexto_etapa_4.json |

### Comandos Especiais:
```bash
/status    # Ver progresso (ler sessao_atual.json)
/context   # Ver contexto atual (cat temp/*.json)
/reset     # Limpar contexto (rm temp/*.json)
/help      # Ajuda detalhada
/back      # Voltar etapa anterior
```

---

## 📊 Métricas de Qualidade
```
📊 MÉTRICAS FINAIS

Código:
- LOC: +[add]/-[remove] linhas
- Arquivos: [created] novos, [modified] modificados
- Complexidade: [média] (< 10)
- Duplicação: [%] (META: 0%)

Testes:
- Unit: [passed]/[total]
- Integration: [passed]/[total]
- Cobertura: [%] (META: > 80%)

Arquitetura:
- Funções reutilizadas: [n]
- Gates: [n] (default: legacy)
- Código preservado: [n] blocos

Git:
- Commits: [n]
- Branch: [nome]
- CHANGELOG: [✓/✗]
```

---

## ⚠️ Notas Importantes

- Dual database: `db.sqlite3` + `scheduler.sqlite3`
- Redis necessário para cache
- Scheduler = processo separado
- Geração com lock em arquivo
- Frontend: flags local/prod
- **Contexto salvo em prompt_mestre/temp/**
- **Sempre seguir workflow por etapas**
- **Qualidade > Velocidade**

---

**Versão**: 3.0 PT-BR + Contexto Persistente (02/11/2025)  
**Última Atualização**: Sistema de contexto por arquivos JSON
