# ETAPA 2 - IMPLEMENTACAO (Incremental + Provavel)

**Versao**: 3.0 | **Compatibilidade**: Todos os LLMs | **Data**: 02/11/2025

**Objetivo**: Implementar o plano da Etapa 1 de forma incremental, com evidencias de funcionamento em cada passo, reuso maximo de codigo existente, e validacao continua.

**Tempo estimado**: Variavel (depende da complexidade)

---

## CARREGAR CONTEXTO DAS ETAPAS ANTERIORES (Obrigatorio)
````bash
# Verificar se etapas 0 e 1 foram concluidas
if [ ! -f prompt_mestre/temp/contexto_etapa_0.json ]; then
  echo "ERRO: Etapa 0 nao foi concluida!"
  exit 1
fi

if [ ! -f prompt_mestre/temp/contexto_etapa_1.json ]; then
  echo "ERRO: Etapa 1 nao foi concluida!"
  exit 1
fi

echo "=== CONTEXTO ETAPA 0 (Analise) ==="
cat prompt_mestre/temp/contexto_etapa_0.json
echo ""
echo "=== CONTEXTO ETAPA 1 (Planejamento) ==="
cat prompt_mestre/temp/contexto_etapa_1.json
echo ""
echo "Contextos carregados com sucesso!"
echo "Pressione ENTER para iniciar implementacao..."
````

---

## PRINCIPIOS DE IMPLEMENTACAO

### 1. INCREMENTAL
- Implementar em pequenos passos
- Validar cada passo antes de avancar
- Possibilidade de rollback a qualquer momento

### 2. PROVAVEL (Anti-alucinacao)
- Mostrar codigo REAL antes de modificar
- Executar comandos e mostrar resultados
- Evidencias de que cada passo funcionou

### 3. REUSO-PRIMEIRO
- Sempre buscar codigo existente para reutilizar
- Evitar duplicacao de logica
- Compor ao invés de reescrever

### 4. BACKWARD-COMPATIBLE
- Usar feature flags
- Manter comportamento legacy funcionando
- Permitir rollback instantaneo

---

## PROCESSO DE IMPLEMENTACAO

### FASE 1: PREPARACAO

**Objetivo**: Criar estrutura base sem quebrar nada existente

#### PASSO 1.1: Criar pastas necessarias
````bash
# Verificar se pastas existem
echo "Verificando estrutura de pastas..."

# Listar pastas que serao criadas (baseado no planejamento)
# Exemplo: mkdir -p gerador_conteudo/services
# Exemplo: mkdir -p gerador_conteudo/tests

echo "Pastas a criar:"
echo "  - [listar baseado na etapa 1]"
echo ""
echo "Criar pastas? (s/n)"
````

**Template de comando**:
````bash
# Criar pasta se nao existir
mkdir -p caminho/para/pasta
echo "Pasta criada: caminho/para/pasta"
````

**Validacao**:
````bash
# Verificar que pasta foi criada
ls -la caminho/para/pasta
````

---

#### PASSO 1.2: Adicionar feature flags

**Objetivo**: Preparar toggles para ativar/desativar novo codigo

**Comandos**:
````bash
# Ver arquivo de configuracao atual
echo "=== Arquivo atual: setup/settings.py ==="
tail -20 setup/settings.py

echo ""
echo "Adicionar feature flags ao final do arquivo? (s/n)"
````

**Template de adicao**:
````bash
# Garantir que bloco nao existe antes de anexar (idempotente)
if rg "FEATURE FLAGS - Etapa 2 Implementacao" setup/settings.py >/dev/null 2>&1; then
  echo "Bloco de feature flags ja presente — revisar antes de duplicar"
else
  # Adicionar feature flags ao settings.py
  cat >> setup/settings.py << 'EOFFLAGS'

# ============================================
# FEATURE FLAGS - Etapa 2 Implementacao
# ============================================
# FEATURE_[NOME] = False  # Default: comportamento legacy
# Adicione aqui os flags do planejamento
EOFFLAGS
  echo "Feature flags adicionadas!"
fi
````

**Validacao**:
````bash
# Verificar que flags foram adicionadas
tail -10 setup/settings.py
````

---

#### PASSO 1.3: Criar arquivos esqueleto

**Objetivo**: Criar estrutura basica dos novos arquivos

**Template**:
````bash
# Criar arquivo novo com estrutura basica
cat > caminho/arquivo_novo.py << 'EOFNOVO'
"""
Modulo: [Nome do Modulo]
Proposito: [Descricao do proposito]
Criado em: Etapa 2 - Implementacao
"""

# Imports necessarios
# TODO: Adicionar imports

# Classes e funcoes
# TODO: Implementar
EOFNOVO

echo "Arquivo criado: caminho/arquivo_novo.py"
````

**Validacao**:
````bash
# Verificar que arquivo foi criado
cat caminho/arquivo_novo.py
````

---

### FASE 2: IMPLEMENTACAO CORE

**Objetivo**: Implementar funcionalidade principal, passo a passo

#### PASSO 2.1: Implementar codigo reutilizando existente

**Fluxo**:

1. **Ver codigo existente que sera reutilizado**
````bash
# Mostrar codigo existente
echo "=== Codigo existente a reutilizar ==="
cat app_search_google/cache.py | grep -A 20 "class RedisCache"
````

2. **Criar novo codigo que REUTILIZA o existente**
````bash
# Criar servico que USA o codigo existente
if rg "class ReportCacheService" gerador_conteudo/cache_service.py >/dev/null 2>&1; then
  echo "ReportCacheService ja existe — avaliar ajustes em vez de recriar"
else
  cat > gerador_conteudo/cache_service.py << 'EOFSERVICE'
"""
Cache Service
Reutiliza RedisCache existente de app_search_google
"""

from app_search_google.cache import RedisCache

class ReportCacheService:
    def __init__(self):
        # REUSO: Usa RedisCache existente
        self.cache = RedisCache()
    
    def get_cached_report(self, report_type):
        """Busca relatorio no cache"""
        cache_key = f"report:{report_type}"
        return self.cache.get(cache_key)
    
    def set_cached_report(self, report_type, data, ttl=300):
        """Salva relatorio no cache"""
        cache_key = f"report:{report_type}"
        return self.cache.set(cache_key, data, ttl)
EOFSERVICE

  echo "Servico criado com REUSO de codigo existente!"
fi
````

3. **Validar que codigo nao tem erros de sintaxe**
````bash
# Validar sintaxe Python
python -m py_compile gerador_conteudo/cache_service.py
echo "Sintaxe validada: OK"
````

---

#### PASSO 2.2: Integrar com codigo existente usando feature flag

**Fluxo**:

1. **Ver codigo existente que sera modificado**
````bash
# Mostrar funcao atual
echo "=== Funcao ANTES da modificacao ==="
cat gerador_conteudo/reports.py | grep -A 30 "def generate_report"
````

2. **Fazer backup do arquivo**
````bash
# Backup antes de modificar
cp gerador_conteudo/reports.py gerador_conteudo/reports.py.backup
echo "Backup criado: reports.py.backup"
````

3. **Modificar codigo adicionando feature flag**

**Usar um dos metodos abaixo**:

**METODO A: Substituicao com sed** (quando mudanca e pontual)
````bash
# Substituir linha especifica
sed -i 's/antiga_linha/nova_linha/' gerador_conteudo/reports.py
````

**METODO B: Criar arquivo completo** (quando mudancas sao grandes)
````bash
# Criar nova versao do arquivo
cat > gerador_conteudo/reports.py << 'EOFREPORTS'
# Conteudo completo do arquivo aqui
# Com as modificacoes necessarias
EOFREPORTS
````

**METODO C: Patch incremental** (recomendado)
````bash
# Adicionar import no topo
sed -i '1i from django.conf import settings' gerador_conteudo/reports.py
sed -i '2i from gerador_conteudo.cache_service import ReportCacheService' gerador_conteudo/reports.py

# Modificar funcao especifica (exemplo conceitual)
# Nota: sed pode ser complicado para mudancas grandes
# Melhor fazer manualmente ou usar METODO B
````

**Template de codigo com feature flag**:
````python
from django.conf import settings
from gerador_conteudo.cache_service import ReportCacheService

def generate_report(report_type):
    """
    Gera relatorio
    Feature flag: FEATURE_REPORT_CACHE
    """
    if settings.FEATURE_REPORT_CACHE:
        # NOVO COMPORTAMENTO: Com cache
        cache_service = ReportCacheService()
        cached = cache_service.get_cached_report(report_type)
        if cached:
            return cached
        
        # Cache miss, gerar e cachear
        result = _generate_report_from_db(report_type)
        cache_service.set_cached_report(report_type, result)
        return result
    else:
        # COMPORTAMENTO LEGACY: Sem cache
        return _generate_report_from_db(report_type)

def _generate_report_from_db(report_type):
    """Codigo original mantido intacto"""
    # Logica existente aqui
    pass
````

4. **Validar modificacao**
````bash
# Verificar sintaxe
python -m py_compile gerador_conteudo/reports.py
echo "Sintaxe validada: OK"

# Ver diferenca
diff gerador_conteudo/reports.py.backup gerador_conteudo/reports.py
````

---

#### PASSO 2.3: Rodar formatadores e linters do projeto
````bash
# Python
python -m black gerador_conteudo/cache_service.py gerador_conteudo/reports.py
python -m ruff check gerador_conteudo/cache_service.py gerador_conteudo/reports.py

# Front-end ou outros (executar somente se aplicavel)
if [ -d front-end ]; then
  (cd front-end && npm run lint && npm run format)
fi
````

> Se algum comando nao estiver instalado, registrar a saida e justificar no relatorio da etapa.

---

#### PASSO 2.4: Validar que codigo legacy ainda funciona

**CRITICO: Antes de prosseguir, garantir que nada quebrou**
````bash
# Executar testes existentes
echo "=== Executando testes existentes ==="
python manage.py test gerador_conteudo.tests

# Se testes passarem
echo "Testes passaram: OK"
echo "Codigo legacy ainda funciona!"

# Se testes falharem
echo "ERRO: Testes falharam!"
echo "Rollback necessario"
echo "Restaurar? (s/n)"
````

**Comando de rollback se necessario**:
````bash
# Restaurar backup
cp gerador_conteudo/reports.py.backup gerador_conteudo/reports.py
echo "Rollback executado"
````

---

### FASE 3: TESTES DO NOVO CODIGO

**Objetivo**: Criar testes para validar novo comportamento

#### PASSO 3.1: Criar testes unitarios
````bash
# Criar arquivo de testes
cat > gerador_conteudo/tests/test_cache_service.py << 'EOFTESTS'
"""
Testes para ReportCacheService
"""
from django.test import TestCase
from gerador_conteudo.cache_service import ReportCacheService

class TestReportCacheService(TestCase):
    def setUp(self):
        self.service = ReportCacheService()
    
    def test_get_cached_report_when_missing(self):
        """Deve retornar None quando cache vazio"""
        result = self.service.get_cached_report("test")
        self.assertIsNone(result)
    
    def test_set_and_get_cached_report(self):
        """Deve salvar e recuperar do cache"""
        data = {"report": "data"}
        self.service.set_cached_report("test", data)
        result = self.service.get_cached_report("test")
        self.assertEqual(result, data)
    
    # Adicionar mais testes conforme planejamento
EOFTESTS

echo "Testes criados: test_cache_service.py"
````

**Validar sintaxe**:
````bash
python -m py_compile gerador_conteudo/tests/test_cache_service.py
echo "Sintaxe dos testes: OK"
````

---

#### PASSO 3.2: Executar testes unitarios
````bash
# Executar APENAS os novos testes
echo "=== Executando testes novos ==="
python manage.py test gerador_conteudo.tests.test_cache_service

# Verificar resultado
if [ $? -eq 0 ]; then
  echo "Testes passaram: OK"
else
  echo "ERRO: Testes falharam!"
  echo "Revisar implementacao"
fi
````

---

#### PASSO 3.3: Testes de integracao
````bash
# Criar testes de integracao
cat > gerador_conteudo/tests/test_report_integration.py << 'EOFINTEGRATION'
"""
Testes de integracao com feature flag
"""
from django.test import TestCase, override_settings
from gerador_conteudo.reports import generate_report

class TestReportIntegration(TestCase):
    @override_settings(FEATURE_REPORT_CACHE=False)
    def test_generate_report_legacy_mode(self):
        """Deve funcionar no modo legacy"""
        result = generate_report("test_type")
        self.assertIsNotNone(result)
    
    @override_settings(FEATURE_REPORT_CACHE=True)
    def test_generate_report_with_cache(self):
        """Deve funcionar com cache ativado"""
        result = generate_report("test_type")
        self.assertIsNotNone(result)
    
    # Adicionar mais testes conforme planejamento
EOFINTEGRATION

echo "Testes de integracao criados"
````

**Executar**:
````bash
python manage.py test gerador_conteudo.tests.test_report_integration
````

---

### FASE 4: VALIDACAO E EVIDENCIAS

**Objetivo**: Provar que implementacao funciona

#### PASSO 4.1: Teste manual com feature flag OFF
````bash
# Configurar flag como OFF
echo "=== Testando com FEATURE_REPORT_CACHE=False ==="

# Executar em ambiente de dev/staging
python manage.py shell << 'EOFSHELL'
from django.conf import settings
settings.FEATURE_REPORT_CACHE = False

from gerador_conteudo.reports import generate_report
result = generate_report("test")
print("Resultado (legacy):", result)
EOFSHELL

echo "Teste manual legacy: OK"
````

---

#### PASSO 4.2: Teste manual com feature flag ON
````bash
# Configurar flag como ON
echo "=== Testando com FEATURE_REPORT_CACHE=True ==="

python manage.py shell << 'EOFSHELL'
from django.conf import settings
settings.FEATURE_REPORT_CACHE = True

from gerador_conteudo.reports import generate_report

# Primeira chamada (cache miss)
print("Primeira chamada (deve buscar do banco):")
result1 = generate_report("test")
print("Resultado:", result1)

# Segunda chamada (cache hit)
print("Segunda chamada (deve vir do cache):")
result2 = generate_report("test")
print("Resultado:", result2)

# Validar que resultados sao iguais
assert result1 == result2
print("Cache funcionando: OK")
EOFSHELL

echo "Teste manual com cache: OK"
````

---

#### PASSO 4.3: Medir performance
````bash
# Script de benchmark
cat > benchmark_reports.py << 'EOFBENCH'
import time
from django.conf import settings
from gerador_conteudo.reports import generate_report

def benchmark(flag_value, iterations=10):
    settings.FEATURE_REPORT_CACHE = flag_value
    times = []
    
    for i in range(iterations):
        start = time.time()
        generate_report("test")
        end = time.time()
        times.append(end - start)
    
    avg = sum(times) / len(times)
    return avg

print("Benchmark SEM cache:")
time_without = benchmark(False)
print(f"Tempo medio: {time_without:.3f}s")

print("\nBenchmark COM cache:")
time_with = benchmark(True)
print(f"Tempo medio: {time_with:.3f}s")

improvement = ((time_without - time_with) / time_without) * 100
print(f"\nMelhoria: {improvement:.1f}%")
EOFBENCH

# Executar benchmark
python benchmark_reports.py

# Decida se o script faz parte do escopo final. Caso seja apenas auxiliar, remova-o com `rm benchmark_reports.py` apos registrar os resultados para evitar artefatos temporarios no commit.
````

---

### FASE 5: DOCUMENTACAO

**Objetivo**: Documentar mudancas para time

#### PASSO 5.1: Criar CHANGELOG
````bash
cat > CHANGELOG_etapa_2.md << 'EOFCHANGELOG'
# CHANGELOG - Etapa 2: Implementacao

## Data: 2025-11-02

## Arquivos Criados
- gerador_conteudo/cache_service.py (150 linhas)
  - ReportCacheService: Servico de cache para relatorios
  - Reutiliza RedisCache existente

- gerador_conteudo/tests/test_cache_service.py (80 linhas)
  - Testes unitarios para cache service

- gerador_conteudo/tests/test_report_integration.py (60 linhas)
  - Testes de integracao com feature flag

## Arquivos Modificados
- gerador_conteudo/reports.py
  - Funcao generate_report() agora suporta cache
  - Feature flag: FEATURE_REPORT_CACHE
  - Comportamento legacy mantido quando flag=False

- setup/settings.py
  - Adicionado: FEATURE_REPORT_CACHE = False

## Feature Flags
- FEATURE_REPORT_CACHE
  - Default: False (comportamento legacy)
  - Quando True: Usa cache Redis
  - Rollback: Mudar para False

## Testes
- Testes unitarios: 12 novos (todos passando)
- Testes integracao: 5 novos (todos passando)
- Testes regressao: 45 existentes (todos passando)

## Performance
- Tempo sem cache: ~1.5s
- Tempo com cache: ~0.3s
- Melhoria: 80%

## Proximo Passo
- Etapa 3: Testes completos
- Etapa 4: Deploy gradual

## Rollback
Se necessario:
1. Mudar FEATURE_REPORT_CACHE = False
2. Restaurar backups em gerador_conteudo/*.backup
EOFCHANGELOG

echo "Changelog criado: CHANGELOG_etapa_2.md"
````

---

#### PASSO 5.2: Atualizar README
````bash
# Adicionar secao no README
cat >> README.md << 'EOFREADME'

## Feature Flags

### FEATURE_REPORT_CACHE
Cache para relatorios usando Redis.

**Status**: Implementado (Etapa 2)
**Default**: False (legacy)

**Como ativar**:
```python
# Em settings.py ou via variavel de ambiente
FEATURE_REPORT_CACHE = True
```

**Rollback**:
```python
FEATURE_REPORT_CACHE = False
```

**Performance**:
- Reducao de 80% no tempo de resposta
- Cache hit rate esperado: >70%
EOFREADME

echo "README atualizado"
````

---

## TEMPLATE DE SAIDA FINAL
````
===============================================================================
ETAPA 2: IMPLEMENTACAO CONCLUIDA
===============================================================================

RESUMO DO QUE FOI IMPLEMENTADO:
* Feature flags adicionadas
* Codigo novo criado com reuso
* Integracao com codigo existente
* Testes criados e executados
* Validacao manual realizada
* Performance medida

===============================================================================
ARQUIVOS CRIADOS
===============================================================================

NOVOS ARQUIVOS:
* gerador_conteudo/cache_service.py (150 linhas)
* gerador_conteudo/tests/test_cache_service.py (80 linhas)
* gerador_conteudo/tests/test_report_integration.py (60 linhas)
* CHANGELOG_etapa_2.md
* benchmark_reports.py

TOTAL: 5 arquivos novos

===============================================================================
ARQUIVOS MODIFICADOS
===============================================================================

MODIFICADOS:
* gerador_conteudo/reports.py
  - Funcao generate_report() com feature flag
  - Backup criado: reports.py.backup

* setup/settings.py
  - Adicionado FEATURE_REPORT_CACHE = False

* README.md
  - Documentacao do feature flag

TOTAL: 3 arquivos modificados

===============================================================================
VALIDACAO
===============================================================================

TESTES UNITARIOS:
* test_cache_service.py: 12 testes - PASSOU

TESTES INTEGRACAO:
* test_report_integration.py: 5 testes - PASSOU

TESTES REGRESSAO:
* Testes existentes: 45 testes - PASSOU

TESTE MANUAL:
* Com flag OFF: FUNCIONOU (legacy)
* Com flag ON: FUNCIONOU (cache)

PERFORMANCE:
* Sem cache: 1.5s
* Com cache: 0.3s
* Melhoria: 80%

===============================================================================
FEATURE FLAGS
===============================================================================

FLAG: FEATURE_REPORT_CACHE
* Valor atual: False (legacy ativo)
* Codigo novo: Implementado e testado
* Codigo legacy: Funcionando
* Pronto para ativacao gradual

===============================================================================
EVIDENCIAS
===============================================================================

1. Todos os testes passando (62 testes total)
2. Benchmark mostra 80% de melhoria
3. Codigo legacy continua funcionando
4. Rollback disponivel (backups criados)
5. Documentacao atualizada

===============================================================================
PROXIMOS PASSOS
===============================================================================

Implementacao: CONCLUIDA
Proxima etapa: ETAPA 3 (Testes Completos)

Para ativar o cache:
1. Mudar FEATURE_REPORT_CACHE = True
2. Monitorar logs e metricas
3. Se houver problema, fazer rollback (mudar para False)

===============================================================================
````

---

## SALVAR CONTEXTO (Automatico)
````bash
cat > prompt_mestre/temp/contexto_etapa_2.json << 'EOFCONTEXT'
{
  "etapa": 2,
  "versao": "3.0",
  "concluida": true,
  "timestamp": "2025-11-02T17:00:00Z",
  "baseado_em_etapa_0": true,
  "baseado_em_etapa_1": true,
  "arquivos_criados": [
    "gerador_conteudo/cache_service.py",
    "gerador_conteudo/tests/test_cache_service.py",
    "gerador_conteudo/tests/test_report_integration.py",
    "CHANGELOG_etapa_2.md",
    "benchmark_reports.py"
  ],
  "arquivos_modificados": [
    "gerador_conteudo/reports.py",
    "setup/settings.py",
    "README.md"
  ],
  "backups_criados": [
    "gerador_conteudo/reports.py.backup"
  ],
  "feature_flags": {
    "FEATURE_REPORT_CACHE": {
      "valor_atual": false,
      "implementado": true,
      "testado": true
    }
  },
  "testes": {
    "unitarios": {
      "novos": 12,
      "status": "passou"
    },
    "integracao": {
      "novos": 5,
      "status": "passou"
    },
    "regressao": {
      "existentes": 45,
      "status": "passou"
    },
    "total": 62
  },
  "performance": {
    "sem_cache": "1.5s",
    "com_cache": "0.3s",
    "melhoria_percentual": 80
  },
  "validacao": {
    "sintaxe": true,
    "testes_automaticos": true,
    "teste_manual_legacy": true,
    "teste_manual_novo": true,
    "benchmark": true
  },
  "rollback_disponivel": true
}
EOFCONTEXT

cat > prompt_mestre/temp/sessao_atual.json << 'EOFSESSAO'
{
  "etapa_atual": 2,
  "etapa_concluida": true,
  "proxima_etapa": 3,
  "timestamp": "2025-11-02T17:00:00Z",
  "etapas_concluidas": [0, 1, 2]
}
EOFSESSAO

echo ""
echo "Contexto salvo em:"
echo "   - prompt_mestre/temp/contexto_etapa_2.json"
echo "   - prompt_mestre/temp/sessao_atual.json"
````

---

## VALIDACAO FINAL
````
===============================================================================
CHECKLIST DE VALIDACAO
===============================================================================

[ ] Todos os arquivos novos foram criados?
[ ] Todos os arquivos modificados tem backup?
[ ] Feature flags foram adicionadas?
[ ] Codigo reutiliza existente (nao duplica)?
[ ] Testes unitarios foram criados?
[ ] Testes de integracao foram criados?
[ ] Todos os testes passaram?
[ ] Teste manual com flag OFF funcionou?
[ ] Teste manual com flag ON funcionou?
[ ] Performance foi medida?
[ ] Documentacao foi atualizada?
[ ] Rollback esta disponivel?
[ ] Contexto foi salvo em JSON?

===============================================================================

VALIDACAO FINAL:

A implementacao esta completa e funcional?

Palavras-chave aceitas:
* "IMPLEMENTADO" (principal)
* "CONCLUIDO", "OK", "FUNCIONANDO" (alternativas)

Proxima acao apos aprovacao:
-> Avancar para ETAPA 3 (Testes Completos)
-> Contexto sera carregado automaticamente

===============================================================================
````

---

**Versao**: 3.0  
**Compatibilidade**: Claude, GPT-4, Mistral, Gemini, todos os LLMs  
**Proxima Etapa**: Testes (etapa_3_testes.md)  
**Contexto Salvo**: prompt_mestre/temp/contexto_etapa_2.json
