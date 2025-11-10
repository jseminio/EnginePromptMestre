# Super Agentes Especialistas — Engine Prompt Mestre

**Versão**: 1.0
**Data**: 09/11/2025
**Base**: Consolidação de ai_orchestrator_suite_v2, ai_orchestrator_suite_v3 e promptmestre

---

## INÍCIO RÁPIDO

1. **Carregar o orquestrador**  
   ```bash
   cat EnginePromptMestre/agents/orchestrator.md
   ```  
   O menu 0→4 é exibido automaticamente com status atual.
2. **Documentação essencial**
   | Documento | Caminho |
   |-----------|---------|
   | Regras de Negócio Consolidadas | `acoes/REGRAS_NEGOCIO_CONSOLIDADAS.md` |
   | Workflow 0→4 | `agents/workflow.md` |
   | Validação Completa | `agents/VALIDACAO_COMPLETA.md` |
3. **Diretórios padrão**
   - `agents/` → especialistas autônomos (este arquivo faz o índice).
   - `acoes/` → templates/ações etapa 0→4, contextos e documentação de apoio.
   - `scripts/` → utilitários compartilhados (`context_guard.sh`, etc.).

---

## ÍNDICE DE AGENTES

| Agente | Arquivo | Responsabilidade Principal | Ordem de Execução |
|--------|---------|---------------------------|-------------------|
| **Orquestrador** | `orchestrator.md` | Coordenar fluxo completo 0→4, despachar agentes, consolidar entregas | 1º (sempre) |
| **Arquiteto** | `architect.md` | Definir arquitetura, SPEC, ADRs, contratos de integração | 2º |
| **DBA** | `dba.md` | Modelagem de dados, migrações, rollback, performance de BD | 3º |
| **Backend** | `backend.md` | APIs, serviços, workers, lógica de negócio | 4º |
| **Frontend** | `frontend.md` | Interfaces, componentes, SSR, SEO, acessibilidade | 5º |
| **QA** | `qa.md` | Testes, cobertura, validação, métricas de qualidade | 6º |
| **SRE** | `sre.md` | Deploy, CI/CD, observabilidade, rollback, pipelines | 7º |
| **UX** | `ux.md` | Microcopy, mensagens, consistência linguística, usabilidade | 8º |

---

## ORDEM DE EXECUÇÃO PADRÃO

```
┌─────────────────┐
│  Orquestrador   │ ← Recebe tarefa, planeja execução
└────────┬────────┘
         ↓
┌─────────────────┐
│   Arquiteto     │ ← Define arquitetura e contratos
└────────┬────────┘
         ↓
┌─────────────────┐
│      DBA        │ ← Modela dados e migrações
└────────┬────────┘
         ↓
┌─────────────────┐
│    Backend      │ ← Implementa lógica e APIs
└────────┬────────┘
         ↓
┌─────────────────┐
│   Frontend      │ ← Implementa interfaces
└────────┬────────┘
         ↓
┌─────────────────┐
│      QA         │ ← Valida qualidade e testes
└────────┬────────┘
         ↓
┌─────────────────┐
│      SRE        │ ← Deploy e observabilidade
└────────┬────────┘
         ↓
┌─────────────────┐
│      UX         │ ← Validação final de experiência
└────────┬────────┘
         ↓
┌─────────────────┐
│  Orquestrador   │ ← Consolida e encerra
└─────────────────┘
```

---

## REGRAS GLOBAIS PARA TODOS OS AGENTES

### 1. Idioma
- **Português (Brasil)** em toda comunicação

### 2. Estrutura de Resposta Obrigatória
1. Resumo objetivo (2-3 linhas)
2. Arquivos criados/alterados (paths completos)
3. Código completo (sem omissões)
4. Testes e como rodar
5. Checklist de qualidade
6. STATE atualizado

### 3. Princípios de Engenharia
- SOLID, DRY, KISS, Clean Code
- **Reuso-Primeiro**: Sempre buscar existente antes de criar (regra 80/20 → evoluir artefatos que cubram ≥80% da necessidade antes de propor algo novo)
- Logs estruturados obrigatórios
- Backward compatibility sempre
- Feature flags para mudanças significativas

### 4. Qualidade
- Cobertura de testes ≥ 85%
- Complexidade ciclomática ≤ 10
- Duplicação de código: 0% (meta)
- Zero falhas críticas

### 5. Persistência
- Sempre atualizar contexto em `acoes/temp/`
- Salvar STATE após cada etapa
- Manter histórico de decisões

### 6. DECISION_MODE
- **`DE ACORDO`**: Pausar e aguardar aprovação
- **`AUTOMÁTICO`**: Executar autonomamente com logs

### 7. Anti-Alucinação
- Sempre mostrar código REAL antes de modificar
- Executar comandos e mostrar resultados
- Fornecer evidências de funcionamento
- Nunca assumir sem verificar

### 8. Catálogo de Reuso
- Consultar `acoes/REGRAS_NEGOCIO_CONSOLIDADAS.md` antes de criar novo
- Atualizar catálogo após mudanças
- Documentar componentes reutilizáveis

---

## COMO USAR OS AGENTES

### Passo 1: Iniciar com Orquestrador
```bash
# O orquestrador apresenta menu 0→4 e determina quais agentes acionar
cat EnginePromptMestre/agents/orchestrator.md
```

### Passo 2: Orquestrador Despacha Agentes
O orquestrador decide automaticamente quais agentes são necessários para cada etapa.

### Passo 3: Agentes Executam com Contexto
Cada agente recebe:
- Contexto consolidado das etapas anteriores
- Objetivo específico da etapa
- STATE atual
- Políticas (DECISION_MODE, HISTORY_POLICY)

### Passo 4: Agentes Retornam Entregas
Cada agente entrega:
- Artefatos completos (código, testes, docs)
- STATE atualizado
- Próxima ação recomendada

### Passo 5: Orquestrador Consolida
O orquestrador consolida todas as entregas em pacote final.

---

## MODOS DE OPERAÇÃO

### Modo Manual (Recomendado para Produção)
```json
{
  "DECISION_MODE": "DE ACORDO",
  "HISTORY_POLICY": "strict"
}
```
- Agentes pausam para aprovação
- Histórico completo preservado
- Máxima segurança

### Modo Automático (Para Tarefas Bem Definidas)
```json
{
  "DECISION_MODE": "AUTOMÁTICO",
  "HISTORY_POLICY": "strict"
}
```
- Agentes executam autonomamente
- Histórico preservado
- Decisões logadas

### Modo Stateless (Para Testes)
```json
{
  "DECISION_MODE": "AUTOMÁTICO",
  "HISTORY_POLICY": "ignore"
}
```
- Sem histórico anterior
- Execução isolada
- Para experimentação

---

## WORKFLOW ESTRUTURADO

Ver detalhes completos em: `workflow.md`

### Etapa 0: Análise (Orquestrador)
- Mapear reuso, riscos, evidências
- Salvar em `acoes/temp/contexto_etapa_0.json`
- Aprovação: `ANALISADO`

### Etapa 1: Planejamento (Arquiteto + DBA/UX se necessário)
- Arquitetura, arquivos, testes, feature flags
- Salvar em `acoes/temp/contexto_etapa_1.json`
- Aprovação: `PLANEJADO`

### Etapa 2: Implementação (Backend + Frontend + DBA + UX)
- Código incremental com gates
- Salvar em `acoes/temp/contexto_etapa_2.json`
- Aprovação: `IMPLEMENTADO`

### Etapa 3: Testes (QA + agentes anteriores se ajustes)
- Validação completa, métricas, evidências
- Salvar em `acoes/temp/contexto_etapa_3.json`
- Aprovação: `VALIDADO`

### Etapa 4: Deploy (SRE + UX)
- Git, release, comunicação
- Salvar em `acoes/temp/contexto_etapa_4.json`
- Aprovação: `DEPLOYADO`

---

## REFERÊNCIAS

- **Regras Consolidadas**: `../acoes/REGRAS_NEGOCIO_CONSOLIDADAS.md`
- **Workflow Detalhado**: `workflow.md`
- **Orquestrador**: `orchestrator.md`
- **Etapas Promptmestre**: `../acoes/etapa_*.md`

---

## COMPATIBILIDADE

Estes agentes consolidam o melhor de:
- **ai_orchestrator_suite_v2**: Estrutura base, agentes especializados, STATE
- **ai_orchestrator_suite_v3**: Failover, DECISION_MODE, catálogo de reuso
- **promptmestre**: Workflow 0→4, anti-alucinação, feature flags, persistência

**Resultado**: Super agentes com todas as regras de negócio unificadas.

---

**Engine Prompt Mestre v1.0** — Blueprint-Based AI Orchestration
