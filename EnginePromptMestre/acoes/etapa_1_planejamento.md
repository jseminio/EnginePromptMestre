# ETAPA 1 - PLANEJAMENTO (Reuso-Primeiro + Gates)

**Versao**: 3.0 | **Compatibilidade**: Todos os LLMs | **Data**: 02/11/2025

**Objetivo**: Transformar a analise em plano de execucao incremental, com reuso maximo, eliminacao de duplicacoes, feature flags para backward compatibility, e alinhamento de observabilidade, seguranca e performance.

**Tempo estimado**: 10-20 minutos

---

## CARREGAR CONTEXTO DA ETAPA 0 (Obrigatorio)
```bash
if [ ! -f acoes/temp/contexto_etapa_0.json ]; then
  echo "ERRO: Etapa 0 nao foi concluida!"
  echo "Execute a Etapa 0 (Analise) antes de prosseguir."
  exit 1
fi

echo "Carregando contexto da Etapa 0..."
cat acoes/temp/contexto_etapa_0.json
echo ""
echo "Contexto carregado com sucesso!"
```

---

## ENTRADA NECESSARIA DO USUARIO

### 1. Confirmar Escopo da Analise:
```
O escopo da analise esta correto?
Algo mudou desde a Etapa 0?
```

### 2. Prioridades e Restricoes:
```
Ha alguma restricao de tempo, orcamento ou recursos?
Alguma parte deve ser priorizada?
```

---

## PROCESSO DE PLANEJAMENTO (8 Passos)

### PASSO 1: Revisar Insumos da Analise

**Comandos para revisar**:
```bash
echo "=== RESUMO DA ANALISE ==="
cat acoes/temp/contexto_etapa_0.json | grep -A 10 "tarefa_descricao"
cat acoes/temp/contexto_etapa_0.json | grep -A 20 "arquivos_identificados"
cat acoes/temp/contexto_etapa_0.json | grep -A 10 "funcoes_reuso"
cat acoes/temp/contexto_etapa_0.json | grep -A 10 "riscos"
```

---

### PASSO 2: Definir Objetivos e Resultados Esperados

**Template de Objetivos**:
```
OBJETIVO 1: [Descricao clara e mensuravel]
  - Vinculo com analise: [referencia]
  - Criterio de aceite: [como saber que foi atingido]
  - Prioridade: [Alta/Media/Baixa]
```

**Exemplo**:
```
OBJETIVO 1: Adicionar cache Redis nos relatorios
  - Vinculo com analise: funcoes_reuso RedisCache.get
  - Criterio de aceite: Tempo de resposta menor que 500ms
  - Prioridade: Alta
```

---

### PASSO 3: Estrategia de Entrega (Fases/Trilhas)

**Entrega Incremental (Recomendada)**:
```
FASE 1: Preparacao e Infraestrutura
  - Criar estrutura base
  - Adicionar feature flags
  - Preparar testes

FASE 2: Implementacao Core
  - Implementar funcionalidade principal
  - Integrar com codigo existente
  - Testes unitarios

FASE 3: Integracao e Validacao
  - Testes de integracao
  - Validacao de performance
  - Ajustes finais

FASE 4: Ativacao Gradual
  - Rollout com feature flag
  - Monitoramento
  - Ajustes baseados em metricas
```

---

### PASSO 4: Mapear Artefatos (Arquivos)

**Exemplo**:
```
CRIAR:
  - gerador_conteudo/cache_service.py
    Proposito: Servico centralizado de cache
    Reuso: Usa RedisCache existente

MODIFICAR:
  - gerador_conteudo/reports.py
    Linhas: 45-120
    Motivo: Adicionar cache antes de consultar banco
    
  - setup/settings.py
    Linhas: adicionar no final
    Motivo: Adicionar FEATURE_REPORT_CACHE

LER/APOIAR-SE:
  - app_search_google/cache.py
    Finalidade: Reutilizar classe RedisCache existente
```

---

### PASSO 5: Estrategia de Reuso

**Template**:
```
REUSO 1: [arquivo:linhas] -> [funcao/classe]
  Estrategia: [extender/adaptar/substituir/compor]
  Como garantir compatibilidade:
    - [passo 1]
    - [passo 2]
  Testes de regressao necessarios:
    - [teste 1]
    - [teste 2]
```

**Exemplo**:
```
REUSO 1: app_search_google/cache.py:10-25 -> RedisCache
  Estrategia: COMPOR (usar como dependencia)
  Como garantir compatibilidade:
    - Importar RedisCache no novo modulo
    - Criar wrapper se necessario
    - Manter assinatura original intacta
  Testes de regressao:
    - Testar que cache existente continua funcionando
    - Testar timeout e TTL
```

---

### PASSO 6: Eliminacao de Duplicidades

**Template**:
```
DUPLICACAO 1: [arquivo1] <-> [arquivo2]
  Codigo duplicado: [descricao]
  Abordagem: [extrair helper/centralizar/remover]
  Plano de unificacao:
    1. [passo 1]
    2. [passo 2]
  Garantia de nao-regressao:
    - [teste 1]
    - [teste 2]
```

---

### PASSO 7: Feature Flags e Backward Compatibility

**Template**:
```
GATE 1: FEATURE_[NOME]
  Nome: FEATURE_REPORT_CACHE
  Valor padrao: False (comportamento legacy)
  Escopo: Backend
  Condicao de ativacao: Manual ou gradual
  Plano de rollback:
    - Mudar flag para False
    - Limpar cache se necessario
    - Logs indicam modo legacy ativo
```

---

### PASSO 8: Planejar Testes

**Categorias necessarias**:

**Testes Unitarios**:
```
test_cache_service.py:
  - test_get_cached_report_when_exists
  - test_get_cached_report_when_missing
  - test_cache_expires_after_ttl
  - test_cache_handles_redis_down
```

**Testes de Integracao**:
```
test_report_integration.py:
  - test_full_flow_with_cache
  - test_full_flow_without_cache
  - test_cache_invalidation_on_data_change
```

**Testes de Regressao**:
```
Executar todos os testes existentes
Garantir zero testes quebrados
```

**Testes de Performance**:
```
test_report_performance.py:
  - test_baseline_without_cache
  - test_improved_with_cache
  - test_fallback_performance
```

---

## TEMPLATE DE SAIDA FINAL
```
===============================================================================
ETAPA 1: PLANEJAMENTO COMPLETO
===============================================================================

INSUMOS DA ANALISE (Etapa 0):
* Tarefa: [da etapa 0]
* Arquivos identificados: [listar]
* Funcoes para reuso: [listar]
* Riscos: [listar]

===============================================================================
1. OBJETIVOS E RESULTADOS ESPERADOS
===============================================================================

OBJETIVO 1: [Descricao]
  - Vinculo com analise: [referencia]
  - Criterio de aceite: [mensuravel]
  - Prioridade: [Alta/Media/Baixa]

===============================================================================
2. ESTRATEGIA DE ENTREGA
===============================================================================

FASE 1: Preparacao e Infraestrutura (Dia 1)
  - Criar cache_service.py
  - Adicionar FEATURE_REPORT_CACHE flag
  - Preparar estrutura de testes

FASE 2: Implementacao Core (Dias 2-3)
  - Implementar CacheService
  - Modificar generate_report com gate
  - Testes unitarios

FASE 3: Integracao e Validacao (Dia 4)
  - Testes de integracao
  - Testes de performance
  - Ajustes baseados em metricas

FASE 4: Ativacao Gradual (Dia 5+)
  - Rollout: 0 porcento -> 100 porcento
  - Monitoramento continuo
  - Ajustes conforme necessario

===============================================================================
3. ARTEFATOS (Arquivos)
===============================================================================

CRIAR:
* gerador_conteudo/cache_service.py (150 linhas estimadas)
  - Proposito: Servico centralizado de cache
  - Reuso: Usa RedisCache existente

MODIFICAR:
* gerador_conteudo/reports.py
  - Linhas: 45-120
  - Motivo: Adicionar integracao com cache

* setup/settings.py
  - Linhas: final do arquivo
  - Motivo: Adicionar FEATURE_REPORT_CACHE

LER/APOIAR-SE:
* app_search_google/cache.py
  - Finalidade: Reutilizar RedisCache

===============================================================================
4. ESTRATEGIA DE REUSO
===============================================================================

REUSO 1: app_search_google/cache.py -> RedisCache
  Estrategia: COMPOR (usar como dependencia)
  Compatibilidade: Nao modificar codigo original
  Testes: cache existente deve continuar funcionando

===============================================================================
5. FEATURE FLAGS E BACKWARD COMPATIBILITY
===============================================================================

GATE 1: FEATURE_REPORT_CACHE
  Valor padrao: False (legacy mantido)
  Ativacao graduada: 0 -> 10 -> 50 -> 100 porcento
  Rollback: Mudar para False e limpar cache

===============================================================================
6. TESTES PLANEJADOS
===============================================================================

TESTES UNITARIOS: 20 testes
TESTES DE INTEGRACAO: 5 testes
TESTES DE REGRESSAO: 45 testes (existentes)
TESTES DE PERFORMANCE: 3 testes
TOTAL: 73 testes

Cobertura: maior ou igual 90 porcento para codigo novo

===============================================================================
7. METRICAS E METAS
===============================================================================

CODIGO:
* LOC estimado: mais 150 linhas
* Arquivos novos: 2
* Arquivos modificados: 3
* Duplicacao: 0 porcento (meta)

PERFORMANCE:
* Tempo de resposta: menor que 500ms (com cache)
* Cache hit rate: maior que 70 porcento

===============================================================================
```

---

## SALVAR CONTEXTO (Automatico)

Ao finalizar, o assistente deve executar:
```bash
cat > acoes/temp/contexto_etapa_1.json << 'EOFCONTEXT'
{
  "etapa": 1,
  "versao": "3.0",
  "concluida": true,
  "timestamp": "2025-11-02T16:00:00Z",
  "baseado_em_etapa_0": true,
  "objetivos": [],
  "estrategia_entrega": {},
  "entregaveis": {},
  "reuse_map": [],
  "gates": [],
  "testes_planejados": {},
  "metricas_planejadas": {}
}
EOFCONTEXT

cat > acoes/temp/sessao_atual.json << 'EOFSESSAO'
{
  "etapa_atual": 1,
  "etapa_concluida": true,
  "proxima_etapa": 2,
  "timestamp": "2025-11-02T16:00:00Z",
  "etapas_concluidas": [0, 1]
}
EOFSESSAO

echo ""
echo "Contexto salvo em:"
echo "   - acoes/temp/contexto_etapa_1.json"
echo "   - acoes/temp/sessao_atual.json"
```

---

## VALIDACAO FINAL
```
===============================================================================
CHECKLIST DE VALIDACAO
===============================================================================

[ ] Objetivos sao mensuravelis?
[ ] Estrategia de entrega esta clara?
[ ] Arquivos a criar/modificar listados?
[ ] Estrategia de reuso definida?
[ ] Feature flags com rollback plan?
[ ] Testes planejados?
[ ] Metricas e SLOs definidos?
[ ] Contexto salvo em JSON?

===============================================================================

VALIDACAO FINAL:

Este planejamento esta completo e pode ser implementado?

Palavras-chave aceitas:
* "PLANEJADO" (principal)
* "DE ACORDO", "APROVAR", "OK" (alternativas)

Proxima acao apos aprovacao:
-> Avancar para ETAPA 2 (Implementacao)
-> Contexto sera carregado automaticamente

===============================================================================
```

---

**Versao**: 3.0  
**Compatibilidade**: Claude, GPT-4, Mistral, Gemini, todos os LLMs  
**Proxima Etapa**: Implementacao (etapa_2_implementacao.md)  
**Contexto Salvo**: acoes/temp/contexto_etapa_1.json
