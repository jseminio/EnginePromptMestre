# ANÁLISE: Centralização de Configurações em runtime_config.json

**Data**: 06/11/2025
**Projeto**: AiNoticia
**Versão**: 2.4 → 2.5
**Analista**: DevOps & Django Specialist

---

## 📋 SUMÁRIO EXECUTIVO

**Objetivo**: Centralizar TODAS as configurações do sistema em `config/runtime_config.json`, eliminando a necessidade de:
- Arquivo `.env`
- Defaults espalhados em `_DEFAULT_ENV`
- Múltiplos locais de configuração

**Benefícios**:
- ✅ **Configuração única**: Um só arquivo para modificar
- ✅ **Validação automática**: Pydantic valida estrutura e tipos
- ✅ **Versionável**: JSON pode ser commitado com segurança (exceto secrets)
- ✅ **Documentação clara**: Estrutura organizada por categorias
- ✅ **Menos erros**: Elimina inconsistências entre .env e defaults

---

## 1️⃣ ESTADO ATUAL DO SISTEMA

### 1.1 Locais de Configuração Atuais

| Local | Quantidade | Propósito | Problema |
|-------|------------|-----------|----------|
| `config/runtime_config.json` | 6 seções | Hosts, portas, URLs, database | ✅ Organizado |
| `setup/settings.py` → `_DEFAULT_ENV` | ~35 variáveis | Defaults embutidos | ⚠️ Duplicação |
| `.env` (se existir) | ~35 variáveis | Override de produção | ⚠️ Desorganizado |
| `setup/settings.py` → config() | ~25 variáveis | Leitura de .env | ⚠️ Espalhado |

**Total**: ~4 locais diferentes para configurar o sistema!

---

### 1.2 Configurações por Categoria

#### A) ✅ JÁ em runtime_config.json (6 seções)

```json
{
  "hosts": [...],           // 6 hosts
  "ports": {...},          // front, api, redis
  "protocols": {...},      // http, https
  "urls": {...},           // api, front
  "database": {...}        // PostgreSQL + fallback SQLite
}
```

**Total**: ~20 configurações

---

#### B) ❌ Em _DEFAULT_ENV (precisa migrar)

**Categoria: Geração de Matérias** (15 configs)
```python
'GENERATION_AUTO_ENABLED': 'True',
'GENERATION_INTERVAL_MINUTES': '5',
'GENERATION_MIN_AGE_MINUTES': '0',
'GENERATION_INTERVAL_HOURS': '4',
'GENERATION_FILE_LOCK_MAX_AGE_MINUTES': '240',
'LIMITE_RODADA_NOTICIA': '1',
'LIMITE_RODADA_ESPORTE': '1',
'LIMITE_RODADA_ENTRETENIMENTO': '1',
'QTD_TRENDS_NOTICIAS': '12',
'QTD_TRENDS_ESPORTE': '7',
'QTD_TRENDS_ENTRETENIMENTO': '7',
'QTD_TRENDS_AGENDADAS': '3',
'GERACAO_CONTEUDO_TIPO': '1',
'GERACAO_CONTEUDO_QTD_CARACTERES': '3000',
'GERACAO_CONTEUDO_QTD_PAGINAS': '1',
```

**Categoria: Sistema** (5 configs)
```python
'DEBUG': 'True',
'SECRET_KEY': "django-insecure-...",
'PUBLISHED_STATUS_VALUE': 'S',
'GNEWS_DECODER_ENABLED': 'True',
'APSCHEDULER_DB_URL': '',
```

**Categoria: Telegram** (3 configs)
```python
'TELEGRAM_TOKEN': '7755776552:AAFWvq9dgbk95ACheLJMs9sLYDaIEOwKYuE',
'TELEGRAM_CHAT_IDS': '640196205,199914950',
'TELEGRAM_UNIFIED_MODE': 'True',
```

**Categoria: Logging** (3 configs)
```python
'LOG_LEVEL': 'DEBUG',
'LOG_BACKUP_DAYS': '30',
'LOG_ROTATE_WHEN': 'midnight',
```

**Categoria: Features** (1 config)
```python
'FEATURE_TRENDS_PAYLOAD_V2': 'True',
```

**Total**: ~27 configurações

---

#### C) ❌ Em settings.py via config() (precisa migrar)

**Categoria: Scheduler Jobs** (8 configs)
```python
GENERATION_TICK_MINUTES = config('GENERATION_TICK_MINUTES', default=5)
HEALTH_CHECK_INTERVAL_MINUTES = config('HEALTH_CHECK_INTERVAL_MINUTES', default=15)
CLEANUP_INTERVAL_MINUTES = config('CLEANUP_INTERVAL_MINUTES', default=60)
WATCHDOG_INTERVAL_MINUTES = config('WATCHDOG_INTERVAL_MINUTES', default=30)
GEMINI_RESET_INTERVAL_HOURS = config('GEMINI_RESET_INTERVAL_HOURS', default=4)
ENABLE_AUTO_HEALTH_CHECK = config('ENABLE_AUTO_HEALTH_CHECK', default=True)
ENABLE_AUTO_CLEANUP = config('ENABLE_AUTO_CLEANUP', default=True)
ENABLE_AUTO_GEMINI_RESET = config('ENABLE_AUTO_GEMINI_RESET', default=True)
ENABLE_SCHEDULER_WATCHDOG = config('ENABLE_SCHEDULER_WATCHDOG', default=True)
```

**Total**: ~8 configurações

---

### 1.3 Total de Configurações a Migrar

| Categoria | Quantidade | Complexidade |
|-----------|------------|--------------|
| Geração | 15 | ⚠️ Média |
| Scheduler | 8 | ✅ Baixa |
| Telegram | 3 | ✅ Baixa |
| Logging | 3 | ✅ Baixa |
| Sistema | 5 | ⚠️ Média |
| Features | 1 | ✅ Baixa |
| **TOTAL** | **35** | **⚠️ Média** |

---

## 2️⃣ ESTRUTURA PROPOSTA

### 2.1 Novo runtime_config.json Completo

Criei arquivo: `prompt_mestre/temp/runtime_config_completo_proposta.json`

**Estrutura Organizada**:
```json
{
  "hosts": [...],           // ✅ Já existe
  "ports": {...},          // ✅ Já existe
  "protocols": {...},      // ✅ Já existe
  "urls": {...},           // ✅ Já existe
  "database": {...},       // ✅ Já existe

  "django": {...},         // ⭐ NOVO (SECRET_KEY, DEBUG, APSCHEDULER_DB_URL)
  "generation": {...},     // ⭐ NOVO (auto, interval, limits, trends, content)
  "scheduler": {...},      // ⭐ NOVO (intervals, auto_jobs)
  "telegram": {...},       // ⭐ NOVO (token, chat_ids, unified_mode)
  "logging": {...},        // ⭐ NOVO (level, backup_days, rotate_when)
  "features": {...}        // ⭐ NOVO (feature flags)
}
```

### 2.2 Exemplo: Seção "generation"

```json
"generation": {
  "auto_enabled": true,
  "interval_hours": 4,
  "interval_minutes": null,
  "min_age_minutes": 0,
  "file_lock_max_age_minutes": 240,
  "tick_minutes": 10,
  "manual_generate_token": "",

  "limits_per_round": {
    "noticia": 1,
    "esporte": 1,
    "entretenimento": 1
  },

  "trends": {
    "noticias": 12,
    "esporte": 7,
    "entretenimento": 7,
    "agendadas": 3
  },

  "urls_per_trend": 3,

  "content": {
    "tipo": 1,
    "qtd_caracteres": 3000,
    "qtd_paginas": 1
  },

  "published_status_value": "S",
  "gnews_decoder_enabled": true
}
```

**Vantagens**:
- ✅ Tudo relacionado a geração em um só lugar
- ✅ Hierarquia clara (limits → trends → content)
- ✅ Fácil de encontrar e modificar

---

## 3️⃣ IMPACTO NOS ARQUIVOS

### 3.1 Arquivos a Modificar

| Arquivo | Ação | Linhas Estimadas |
|---------|------|------------------|
| `config/runtime_config.json` | Expandir | +150 linhas |
| `config/runtime.py` | Adicionar modelos Pydantic | +200 linhas |
| `setup/settings.py` | Refatorar _DEFAULT_ENV | -80, +50 linhas |
| `docs/CONFIG.md` | Documentar | +300 linhas |

**Total**: ~500 linhas novas/modificadas

---

### 3.2 Detalhamento: config/runtime.py

**Novos Modelos Pydantic** (7 classes):

```python
class DjangoSettings(BaseModel):
    SECRET_KEY: str
    DEBUG: bool
    APSCHEDULER_DB_URL: str = ""

class GenerationLimits(BaseModel):
    noticia: int
    esporte: int
    entretenimento: int

class GenerationTrends(BaseModel):
    noticias: int
    esporte: int
    entretenimento: int
    agendadas: int

class GenerationContent(BaseModel):
    tipo: int
    qtd_caracteres: int
    qtd_paginas: int

class GenerationSettings(BaseModel):
    auto_enabled: bool
    interval_hours: int
    interval_minutes: int | None
    min_age_minutes: int
    file_lock_max_age_minutes: int
    tick_minutes: int
    manual_generate_token: str = ""
    limits_per_round: GenerationLimits
    trends: GenerationTrends
    urls_per_trend: int
    content: GenerationContent
    published_status_value: str
    gnews_decoder_enabled: bool

class SchedulerAutoJobs(BaseModel):
    health_check: bool
    cleanup: bool
    gemini_reset: bool
    watchdog: bool

class SchedulerSettings(BaseModel):
    health_check_interval_minutes: int
    cleanup_interval_minutes: int
    watchdog_interval_minutes: int
    gemini_reset_interval_hours: int
    auto_jobs: SchedulerAutoJobs

class TelegramSettings(BaseModel):
    token: str
    chat_ids: List[str]
    unified_mode: bool

class LoggingSettings(BaseModel):
    level: str
    backup_days: int
    rotate_when: str

class FeatureFlags(BaseModel):
    trends_payload_v2: bool

class RuntimeConfig(BaseModel):
    hosts: List[str]
    ports: Ports
    protocols: dict[str, bool]
    urls: UrlGroups = Field(default_factory=UrlGroups)
    database: DatabaseSettings | None = None

    # ⭐ NOVOS CAMPOS
    django: DjangoSettings
    generation: GenerationSettings
    scheduler: SchedulerSettings
    telegram: TelegramSettings
    logging: LoggingSettings
    features: FeatureFlags
```

---

### 3.3 Detalhamento: setup/settings.py

**ANTES** (linhas 22-85):
```python
_DEFAULT_ENV = {
    'DEBUG': 'True',
    'SECRET_KEY': "...",
    'GENERATION_AUTO_ENABLED': 'True',
    # ... ~35 variáveis
}

for _k, _v in _DEFAULT_ENV.items():
    os.environ.setdefault(_k, str(_v))
```

**DEPOIS** (simplificado):
```python
# Todas as configs vêm de runtime_config agora
RUNTIME = runtime_config.runtime_settings()

# Django
SECRET_KEY = config('SECRET_KEY', default=RUNTIME.django.SECRET_KEY)
DEBUG = config('DEBUG', default=RUNTIME.django.DEBUG, cast=bool)

# Geração
GENERATION_AUTO_ENABLED = config('GENERATION_AUTO_ENABLED',
                                  default=RUNTIME.generation.auto_enabled,
                                  cast=bool)
GENERATION_INTERVAL_HOURS = config('GENERATION_INTERVAL_HOURS',
                                    default=RUNTIME.generation.interval_hours,
                                    cast=int)
# ... etc para todas as 35 variáveis
```

**Vantagem**:
- `.env` ainda funciona (override)
- Mas defaults vêm de `runtime_config.json`
- Elimina `_DEFAULT_ENV` duplicado

---

## 4️⃣ RISCOS E MITIGAÇÕES

### 🔴 RISCO CRÍTICO 1: Secrets em runtime_config.json

**Descrição**: `runtime_config.json` será commitado no Git. Contém secrets:
- `SECRET_KEY`
- `TELEGRAM_TOKEN`
- `DB_PASSWORD`

**Problema**: Expõe credenciais no repositório!

**Mitigação 1 - Secrets Separados** (⭐ RECOMENDADO):
```json
// config/runtime_config.json (commitado)
{
  "telegram": {
    "token": "${TELEGRAM_TOKEN}",  // placeholder
    "chat_ids": ["640196205", "199914950"]
  }
}

// config/runtime_secrets.json (NÃO commitado)
{
  "TELEGRAM_TOKEN": "7755776552:AAFWvq9dgbk95ACheLJMs9sLYDaIEOwKYuE",
  "SECRET_KEY": "...",
  "DB_PASSWORD": "..."
}
```

Criar `config/runtime.py` que faz merge:
```python
def _load_config():
    # 1. Carrega runtime_config.json
    config = json.load(open('runtime_config.json'))

    # 2. Carrega secrets (se existir)
    if os.path.exists('runtime_secrets.json'):
        secrets = json.load(open('runtime_secrets.json'))
        # 3. Substitui placeholders ${VAR}
        config = _replace_placeholders(config, secrets)

    return RuntimeConfig.model_validate(config)
```

Adicionar ao `.gitignore`:
```
config/runtime_secrets.json
```

**Mitigação 2 - Variáveis de Ambiente** (alternativa):
```python
# config/runtime.py
def _load_config():
    config = json.load(open('runtime_config.json'))

    # Substitui placeholders por env vars
    if config['telegram']['token'] == '${TELEGRAM_TOKEN}':
        config['telegram']['token'] = os.getenv('TELEGRAM_TOKEN', '')

    return RuntimeConfig.model_validate(config)
```

**Recomendação**: ⭐ **Usar Mitigação 1** (arquivo secrets separado)

---

### ⚠️ RISCO MÉDIO 2: Backward Compatibility

**Descrição**: Código existente pode quebrar se não encontrar variáveis em `.env`

**Dependências Encontradas**:
- `gerador_conteudo/views.py`: Lê `settings.TELEGRAM_TOKEN`
- `gerador_conteudo/scheduler.py`: Lê `settings.GENERATION_TICK_MINUTES`
- `gerador_conteudo/automated_generation.py`: Lê `settings.GENERATION_INTERVAL_HOURS`

**Mitigação**:
```python
# settings.py - Manter compatibilidade
TELEGRAM_TOKEN = config('TELEGRAM_TOKEN',
                        default=RUNTIME.telegram.token if RUNTIME.telegram else '')
```

**Testes Necessários**:
- [ ] Código funciona SEM .env (usa runtime_config.json)
- [ ] Código funciona COM .env (override funciona)
- [ ] Testes atuais continuam passando

---

### ⚠️ RISCO MÉDIO 3: Validação de Tipos

**Descrição**: JSON não tem tipos nativos. Pode aceitar valores inválidos.

**Exemplo**:
```json
{
  "generation": {
    "tick_minutes": "dez"  // ❌ String em vez de int!
  }
}
```

**Mitigação**: ✅ **Pydantic faz validação automática!**

```python
# Se JSON tiver tipo errado:
>>> RuntimeConfig.model_validate({"generation": {"tick_minutes": "dez"}})
ValidationError: Input should be a valid integer
```

**Vantagem**: Erros detectados NA INICIALIZAÇÃO, não em runtime!

---

### ✅ RISCO BAIXO 4: Tamanho do Arquivo JSON

**Descrição**: `runtime_config.json` ficará grande (~150 linhas)

**Impacto**: ✅ Mínimo (150 linhas é pequeno)

**Mitigação**: Nenhuma necessária

---

## 5️⃣ PLANO DE IMPLEMENTAÇÃO

### Fase 1: Preparação (1 dia)

**1.1 Criar estrutura de secrets**
```bash
# Criar arquivo de secrets (não commitar)
cp config/runtime_config.json config/runtime_secrets.json
# Editar para deixar só secrets
# Adicionar ao .gitignore
```

**1.2 Expandir runtime_config.json**
- Copiar proposta de `prompt_mestre/temp/runtime_config_completo_proposta.json`
- Substituir secrets por placeholders `${VAR}`
- Validar JSON syntax

**1.3 Adicionar modelos Pydantic**
- Criar 10 novas classes em `config/runtime.py`
- Adicionar loader de secrets
- Testar carregamento

---

### Fase 2: Migração de settings.py (2 dias)

**2.1 Refatorar _DEFAULT_ENV**
- Remover `_DEFAULT_ENV` (linhas 22-85)
- Substituir por leituras de `RUNTIME.*`
- Manter `config()` para permitir override via .env

**2.2 Atualizar todas as 35 variáveis**
```python
# Exemplo para cada variável:
GENERATION_AUTO_ENABLED = config('GENERATION_AUTO_ENABLED',
                                  default=RUNTIME.generation.auto_enabled,
                                  cast=bool)
```

**2.3 Criar exports em runtime.py**
```python
# config/runtime.py (fim do arquivo)
RUNTIME = runtime_settings()

# Django
SECRET_KEY_DEFAULT = RUNTIME.django.SECRET_KEY
DEBUG_DEFAULT = RUNTIME.django.DEBUG

# Generation
GENERATION_AUTO_ENABLED_DEFAULT = RUNTIME.generation.auto_enabled
# ... etc
```

---

### Fase 3: Testes (1 dia)

**3.1 Testes Unitários**
```python
# tests/test_runtime_config.py
def test_load_runtime_config():
    config = runtime_settings()
    assert config.generation.tick_minutes == 10
    assert len(config.hosts) == 6

def test_secrets_placeholder_replacement():
    # Testa substituição de ${VAR}
    pass

def test_backward_compatibility():
    # Testa que .env ainda funciona
    pass
```

**3.2 Testes de Integração**
- [ ] Scheduler inicia com configs de runtime_config.json
- [ ] Geração funciona com novos valores
- [ ] Telegram envia com token de runtime_config.json

---

### Fase 4: Documentação (0.5 dia)

**4.1 Criar docs/CONFIG.md**
- Documentar estrutura do JSON
- Explicar sistema de secrets
- Listar todas as 35+ configurações
- Exemplos de modificação

**4.2 Atualizar CLAUDE.md**
- Seção "Configuração"
- Apontar para `config/runtime_config.json`
- Mencionar `runtime_secrets.json`

---

### Fase 5: Deploy (0.5 dia)

**5.1 Criar runtime_secrets.json em produção**
```bash
# No servidor
cd /home/rockylinux/ainoticia/config/
cp runtime_config.json runtime_secrets.json
# Editar e deixar só secrets
chmod 600 runtime_secrets.json  # Permissão restrita
```

**5.2 Validar funcionamento**
- [ ] Django inicia sem erros
- [ ] Scheduler funciona
- [ ] Geração funciona
- [ ] Logs corretos

---

## 6️⃣ ESTIMATIVA DE ESFORÇO

| Fase | Horas | Dias |
|------|-------|------|
| Preparação | 8h | 1 dia |
| Migração settings.py | 16h | 2 dias |
| Testes | 8h | 1 dia |
| Documentação | 4h | 0.5 dia |
| Deploy | 4h | 0.5 dia |
| **TOTAL** | **40h** | **5 dias** |

**Complexidade**: ⚠️ Média-Alta
**Risco**: ⚠️ Médio (com mitigações vira Baixo)

---

## 7️⃣ COMPARAÇÃO: ANTES vs DEPOIS

### ANTES (Sistema Atual)

**Para mudar GENERATION_TICK_MINUTES de 5 para 10**:

1. Editar `.env`:
   ```
   GENERATION_TICK_MINUTES=10
   ```
2. Ou editar `settings.py` → `_DEFAULT_ENV`:
   ```python
   'GENERATION_TICK_MINUTES': '10',
   ```
3. Reiniciar Django
4. Reiniciar Scheduler

**Problemas**:
- ❌ Não sabe qual prevalece (.env ou _DEFAULT_ENV?)
- ❌ Se esquecer de reiniciar scheduler, não funciona
- ❌ Configuração espalhada em 2 lugares

---

### DEPOIS (Sistema Novo)

**Para mudar GENERATION_TICK_MINUTES de 5 para 10**:

1. Editar `config/runtime_config.json`:
   ```json
   {
     "generation": {
       "tick_minutes": 10
     }
   }
   ```
2. Reiniciar Django
3. Reiniciar Scheduler

**Vantagens**:
- ✅ Um único arquivo para modificar
- ✅ Validação automática (Pydantic detecta erro se colocar "dez" em vez de 10)
- ✅ Organizado por categoria
- ✅ Documentação clara (comments no JSON)
- ✅ Versionável (pode fazer diff, rollback, etc.)

---

## 8️⃣ CHECKLIST DE VALIDAÇÃO

### Antes de Implementar

- [ ] Estrutura JSON proposta foi revisada?
- [ ] Sistema de secrets foi definido?
- [ ] Backward compatibility planejada?
- [ ] Testes foram especificados?
- [ ] Documentação será criada?

### Durante Implementação

- [ ] Modelos Pydantic criam sem erro?
- [ ] JSON valida corretamente?
- [ ] Secrets NÃO estão em runtime_config.json commitado?
- [ ] Todas 35 variáveis foram migradas?
- [ ] settings.py ainda aceita override via .env?

### Antes de Deploy

- [ ] Todos os testes passam?
- [ ] runtime_secrets.json criado em prod?
- [ ] Permissões corretas (600)?
- [ ] Django inicia sem erros?
- [ ] Scheduler funciona?
- [ ] Documentação atualizada?

---

## 9️⃣ RECOMENDAÇÕES FINAIS

### ✅ APROVAÇÕES

1. ✅ **Centralizar em runtime_config.json** - Excelente ideia!
2. ✅ **Usar Pydantic para validação** - Já implementado
3. ✅ **Organizar por categorias** - Mais legível
4. ✅ **Manter override via .env** - Flexibilidade

### ⚠️ AJUSTES OBRIGATÓRIOS

5. ⚠️ **Separar secrets em runtime_secrets.json** - Segurança
6. ⚠️ **Adicionar ao .gitignore** - Não commitar secrets
7. ⚠️ **Documentar sistema de placeholders** - Clareza

### 🔴 ATENÇÃO

8. 🔴 **NÃO commitar secrets no Git!**
9. 🔴 **Testar extensivamente antes de deploy**
10. 🔴 **Ter plano de rollback (backup de settings.py)**

---

## 🎯 CONCLUSÃO

### Viabilidade: ✅ **VIÁVEL E RECOMENDADO**

A centralização em `runtime_config.json` é uma **excelente decisão arquitetural** que:
- Melhora organização
- Reduz erros
- Facilita manutenção
- Permite versionamento

**Porém**, requer **atenção especial com secrets**.

### Próximos Passos:

1. **Usuário revisar este relatório**
2. **Aprovar estrutura JSON proposta**
3. **Decidir sobre sistema de secrets** (arquivo separado ou placeholders)
4. **Confirmar implementação** → Avançar para ETAPA 1 (Planejamento Detalhado)

---

**Arquivo JSON Proposto**: `prompt_mestre/temp/runtime_config_completo_proposta.json`

**Aguardando aprovação para prosseguir...**
