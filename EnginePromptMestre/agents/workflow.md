# Workflow Estruturado — Super Agentes Engine Prompt Mestre

**Versão**: 1.0
**Data**: 09/11/2025
**Compatibilidade**: Todos os LLMs (Claude, GPT-4, Gemini, Mistral)

---

## VISÃO GERAL DO WORKFLOW

O workflow é estruturado em **5 etapas sequenciais** (0→4), cada uma com agentes especializados, entregas obrigatórias e aprovações explícitas.

```
ETAPA 0: ANÁLISE ──→ ETAPA 1: PLANEJAMENTO ──→ ETAPA 2: IMPLEMENTAÇÃO ──→ ETAPA 3: VALIDAÇÃO ──→ ETAPA 4: DEPLOY
    ↓                        ↓                           ↓                         ↓                      ↓
Orquestrador         Arquiteto + DBA/UX          Backend + Frontend        QA + Agentes           SRE + UX
    ↓                        ↓                      + DBA + UX                   ↓                      ↓
ANALISADO               PLANEJADO                  IMPLEMENTADO              VALIDADO              DEPLOYADO
```

---

## TEMPLATE COMPARTILHADO: MENU + STATUS

Todos os agentes devem usar **o mesmo bloco de boot** abaixo para exibir projeto, stack, branch, status atual e comandos especiais. Ajuste apenas os campos entre colchetes de acordo com o contexto carregado.

```bash
cat <<'MENU'
🤖 Orquestrador Fullstack v2.4 — Sistema Inicializado

Projeto: [nome_do_projeto]
Stack: [stack_detectada]
Branch: [git_branch]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📍 Status: [status derivado de acoes/temp/sessao_atual.json]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ETAPAS DISPONÍVEIS (Recomendado: 0→1→2→3→4):
[0] 📊 Análise Contextual — Status: [status_etapa_0]
[1] 📌 Planejamento — Status: [status_etapa_1]
[2] 🧱 Implementação — Status: [status_etapa_2]
[3] ✅ Testes e Métricas — Status: [status_etapa_3]
[4] 🚀 Deploy e CHANGELOG — Status: [status_etapa_4]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
COMANDOS ESPECIAIS:
/status /context /reset /help /back /skip [n]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
MENU
```

> **FEATURE_MENU_TELEMETRIA**: quando habilitada, adicione logo após o bloco de status um resumo de métricas (tempo de boot, backups existentes) coletado pelos scripts descritos na Etapa 2. Quando desativada (default), mantenha o menu minimalista.

Antes de renderizar o menu, execute opcionalmente (via `FEATURE_CONTEXT_GUARD=true`) o script `EnginePromptMestre/scripts/context_guard.sh --file <arquivo>` para validar/registrar backups dos JSONs sensíveis.

---

## ETAPA 0: ANÁLISE CONTEXTUAL

### Objetivo
Coletar contexto essencial, mapear reuso, identificar riscos e provar decisões com evidências reais.

### Agente Responsável
**Orquestrador** (executa diretamente, pode consultar DBA/UX para dados)

### Processo

#### 1. Carregar Contexto Anterior (se existir)
```bash
if [ -f acoes/temp/sessao_atual.json ]; then
  cat acoes/temp/sessao_atual.json
fi
```

#### 2. Entrada do Usuário
- Descrição da tarefa
- Stack tecnológica (auto-detectada)
- Restrições ou prioridades

#### 3. Análise em 6 Passos
1. **Estrutura do Projeto**: `tree -L 2` ou equivalente
2. **Arquivos Relevantes**: `rg "def |class " --type py` ou grep
3. **Código Reutilizável**: Analisar funções/classes existentes
4. **Dependências**: BD, cache, scheduler, APIs externas
5. **Riscos e Conflitos**: Breaking changes, testes faltantes
6. **Métricas de Base**: LOC, complexidade, duplicação, testes

#### 4. Template de Saída
```markdown
===============================================================================
ETAPA 0: ANÁLISE CONTEXTUAL COMPLETA
===============================================================================

TAREFA SOLICITADA: [descrição]
PROJETO: [nome, tipo, stack]

1. ARQUIVOS DIRETAMENTE ENVOLVIDOS
[backend, frontend, config...]

2. CÓDIGO REUTILIZÁVEL IDENTIFICADO
[com evidências REAIS do código]

3. DEPENDÊNCIAS E INTEGRAÇÕES
[BD, cache, jobs, APIs, rotas]

4. RISCOS E CONFLITOS
[com severidade, impacto, mitigação]

5. MÉTRICAS DE BASE (Baseline)
[LOC, complexidade, duplicação, testes]

6. ESTIMATIVA PRELIMINAR
[complexidade, LOC estimado, arquivos, testes, tempo, reuso %]
===============================================================================
```

#### 5. Salvar Contexto
```bash
cat > acoes/temp/contexto_etapa_0.json << 'EOF'
{
  "etapa": 0,
  "concluida": true,
  "timestamp": "...",
  "tarefa_descricao": "...",
  "projeto": {...},
  "arquivos_identificados": [...],
  "funcoes_reuso": [...],
  "dependencias": {...},
  "riscos": [...],
  "baseline": {...},
  "estimativa": {...}
}
EOF
```

### Aprovação Esperada
**`ANALISADO`** (ou OK, CORRETO, SIM, DE ACORDO)

### Próxima Etapa
**Etapa 1: Planejamento**

---

## ETAPA 1: PLANEJAMENTO

### Objetivo
Transformar análise em plano de execução incremental com reuso máximo, eliminação de duplicações e feature flags.

### Agentes Responsáveis
- **Arquiteto** (principal)
- **DBA** (se houver modelagem de dados)
- **UX** (se houver fluxos críticos de usuário)

### Processo

#### 1. Carregar Contexto Etapa 0
```bash
cat acoes/temp/contexto_etapa_0.json
```

#### 2. Planejamento em 8 Passos
1. **Revisar Insumos**: Análise da etapa 0
2. **Definir Objetivos**: Claros e mensuráveis
3. **Estratégia de Entrega**: Fases/trilhas incrementais
4. **Mapear Artefatos**: Arquivos a criar/modificar/ler
5. **Estratégia de Reuso**: Como reutilizar código existente
6. **Eliminar Duplicidades**: Unificar código duplicado
7. **Feature Flags**: Gates para backward compatibility
8. **Planejar Testes**: Unitários, integração, regressão, performance

#### 3. Template de Saída
```markdown
===============================================================================
ETAPA 1: PLANEJAMENTO COMPLETO
===============================================================================

INSUMOS DA ANÁLISE: [resumo etapa 0]

1. OBJETIVOS E RESULTADOS ESPERADOS
[objetivos mensuráveis]

2. ESTRATÉGIA DE ENTREGA
[Fase 1, 2, 3, 4...]

3. ARTEFATOS (Arquivos)
[CRIAR, MODIFICAR, LER/APOIAR-SE]

4. ESTRATÉGIA DE REUSO
[como reutilizar componentes existentes]

5. FEATURE FLAGS E BACKWARD COMPATIBILITY
[gates com rollback plan]

6. TESTES PLANEJADOS
[unitários, integração, regressão, performance]

7. MÉTRICAS E METAS
[LOC, performance, cobertura...]
===============================================================================
```

#### 4. Salvar Contexto
```bash
cat > acoes/temp/contexto_etapa_1.json << 'EOF'
{
  "etapa": 1,
  "concluida": true,
  "timestamp": "...",
  "baseado_em_etapa_0": true,
  "objetivos": [...],
  "estrategia_entrega": {...},
  "artefatos": {...},
  "reuso_map": [...],
  "gates": [...],
  "testes_planejados": {...}
}
EOF
```

### Aprovação Esperada
**`PLANEJADO`** (ou DE ACORDO, APROVAR, OK)

### Próxima Etapa
**Etapa 2: Implementação**

---

## ETAPA 2: IMPLEMENTAÇÃO

### Objetivo
Implementar plano de forma incremental com evidências de funcionamento em cada passo.

### Agentes Responsáveis
**Ordem determinada pelo Orquestrador:**
- **Backend** (se houver lógica de negócio/APIs)
- **Frontend** (se houver interfaces)
- **DBA** (se houver migrações de BD)
- **UX** (se houver mensagens/microcopy)

### Processo

#### 1. Carregar Contextos Etapas 0 e 1
```bash
cat acoes/temp/contexto_etapa_0.json
cat acoes/temp/contexto_etapa_1.json
```

#### 2. Implementação em 5 Fases

**FASE 1: PREPARAÇÃO**
- Criar pastas necessárias
- Adicionar feature flags
- Criar arquivos esqueleto

**FASE 2: IMPLEMENTAÇÃO CORE**
- Implementar código reutilizando existente
- Integrar com código existente usando feature flags
- Validar que código legacy ainda funciona

**FASE 3: TESTES DO NOVO CÓDIGO**
- Criar testes unitários
- Executar testes unitários
- Criar e executar testes de integração

**FASE 4: VALIDAÇÃO E EVIDÊNCIAS**
- Teste manual com feature flag OFF (legacy)
- Teste manual com feature flag ON (novo)
- Medir performance (benchmark)

**FASE 5: DOCUMENTAÇÃO**
- Criar CHANGELOG
- Atualizar README
- Documentar feature flags e rollback

#### 3. Princípios Obrigatórios
- **INCREMENTAL**: Pequenos passos validados
- **PROVÁVEL**: Mostrar código REAL sempre
- **REUSO-PRIMEIRO**: Buscar existente antes de criar
- **BACKWARD-COMPATIBLE**: Feature flags + legacy funcionando

> Roteiro recomendado de validação: `acoes/tests/orchestrator_smoke.md`.

#### 4. Template de Saída
```markdown
===============================================================================
ETAPA 2: IMPLEMENTAÇÃO CONCLUÍDA
===============================================================================

RESUMO: [o que foi implementado]

ARQUIVOS CRIADOS: [lista com LOC]
ARQUIVOS MODIFICADOS: [lista com backups]

VALIDAÇÃO:
- Testes unitários: [X testes - PASSOU]
- Testes integração: [X testes - PASSOU]
- Testes regressão: [X testes - PASSOU]
- Teste manual legacy: FUNCIONOU
- Teste manual novo: FUNCIONOU
- Performance: [baseline vs novo]

FEATURE FLAGS: [nome, valor, rollback]

EVIDÊNCIAS: [todas as validações]

PRÓXIMOS PASSOS: [etapa 3]
===============================================================================
```

#### 5. Salvar Contexto
```bash
cat > acoes/temp/contexto_etapa_2.json << 'EOF'
{
  "etapa": 2,
  "concluida": true,
  "timestamp": "...",
  "arquivos_criados": [...],
  "arquivos_modificados": [...],
  "backups_criados": [...],
  "feature_flags": {...},
  "testes": {...},
  "performance": {...},
  "validacao": {...},
  "rollback_disponivel": true
}
EOF
```

### Aprovação Esperada
**`IMPLEMENTADO`** (ou FEITO, COMPLETO, OK)

### Próxima Etapa
**Etapa 3: Testes e Validação**

---

## ETAPA 3: TESTES E VALIDAÇÃO

### Objetivo
Garantir qualidade através de testes completos, métricas objetivas e evidências.

### Agente Responsável
**QA** (principal, pode acionar Backend/Frontend para ajustes)

### Processo

#### 1. Carregar Contextos Anteriores
```bash
cat acoes/temp/contexto_etapa_0.json
cat acoes/temp/contexto_etapa_1.json
cat acoes/temp/contexto_etapa_2.json
```

#### 2. Execução de Testes

**TESTES UNITÁRIOS**
```bash
python manage.py test --verbosity=2
npm run test
```

**TESTES DE INTEGRAÇÃO**
```bash
python manage.py test --tag=integration
npm run test:integration
```

**TESTES DE REGRESSÃO**
```bash
# TODOS os testes existentes devem passar
python manage.py test
npm run test
```

**TESTES DE PERFORMANCE**
```bash
# Benchmark comparativo
python benchmark_script.py
```

**TESTES DE SEGURANÇA**
```bash
bandit -r backend/
npm audit --production
```

#### 3. Métricas de Qualidade

**Cobertura de Testes**
```bash
coverage run -m pytest
coverage report
# META: ≥ 85%
```

**Complexidade Ciclomática**
```bash
radon cc -s -a .
# META: ≤ 10 por função
```

**Duplicação de Código**
```bash
npx jscpd --threshold 0
# META: 0%
```

#### 4. Template de Saída
```markdown
===============================================================================
ETAPA 3: TESTES E VALIDAÇÃO COMPLETA
===============================================================================

TESTES EXECUTADOS:
- Unitários: X/X passou (100%)
- Integração: X/X passou (100%)
- Regressão: X/X passou (100%)
- Performance: APROVADO (melhoria de X%)
- Segurança: 0 vulnerabilidades críticas

MÉTRICAS DE QUALIDADE:
- Cobertura: X% (≥ 85% ✓)
- Complexidade: X (≤ 10 ✓)
- Duplicação: X% (0% ✓)

EVIDÊNCIAS:
[logs de testes, relatórios, screenshots]

PORTÃO DE QUALIDADE: APROVADO ✓

PRÓXIMOS PASSOS: [etapa 4]
===============================================================================
```

#### 5. Salvar Contexto
```bash
cat > acoes/temp/contexto_etapa_3.json << 'EOF'
{
  "etapa": 3,
  "concluida": true,
  "timestamp": "...",
  "testes": {
    "unitarios": {...},
    "integracao": {...},
    "regressao": {...},
    "performance": {...},
    "seguranca": {...}
  },
  "metricas": {
    "cobertura": X,
    "complexidade": X,
    "duplicacao": X
  },
  "quality_gate": "aprovado"
}
EOF
```

### Aprovação Esperada
**`VALIDADO`** (ou APROVADO, TESTADO, OK)

### Próxima Etapa
**Etapa 4: Deploy e Versionamento**

---

## ETAPA 4: DEPLOY E VERSIONAMENTO

### Objetivo
Preparar release, executar deploy, atualizar documentação e comunicar mudanças.

### Agentes Responsáveis
- **SRE** (principal - deploy e pipelines)
- **UX** (comunicação e anúncios)

### Processo

#### 1. Carregar Todos os Contextos
```bash
cat acoes/temp/contexto_etapa_0.json
cat acoes/temp/contexto_etapa_1.json
cat acoes/temp/contexto_etapa_2.json
cat acoes/temp/contexto_etapa_3.json
```

#### 2. Preparação do Release

**Criar CHANGELOG**
```markdown
# CHANGELOG

## [1.2.0] - 2025-11-09

### Added
- [feature]

### Changed
- [mudanças]

### Fixed
- [bugs corrigidos]

### Rollback
- Como reverter: [passos]
```

**Atualizar README**
```markdown
## Versão 1.2.0

### Novas Features
- [descrição]

### Como Ativar
[instruções com feature flags]
```

#### 3. Git Workflow

**Verificar Status**
```bash
git status
git diff
git log -5 --oneline
```

**Criar Commit**
```bash
git add [arquivos]
git commit -m "$(cat <<'EOF'
✨ feat: [descrição curta]

[descrição detalhada]

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

**Criar Tag**
```bash
git tag -a v1.2.0 -m "Release 1.2.0: [descrição]"
```

**Push (se aprovado)**
```bash
git push origin [branch]
git push origin v1.2.0
```

#### 4. Deploy

**Checklist Pré-Deploy**
- [ ] Todos os testes passando (100%)
- [ ] Cobertura ≥ 85%
- [ ] CHANGELOG atualizado
- [ ] README atualizado
- [ ] Plano de rollback testado
- [ ] Backup criado

**Estratégias de Deploy**
- **Feature Flag**: Deploy com flag=False, ativar gradualmente
- **Blue/Green**: Deploy em ambiente paralelo, switch de tráfego
- **Canary**: Deploy gradual (1% → 5% → 25% → 50% → 100%)

**Checklist Pós-Deploy**
- [ ] Verificar logs de erro
- [ ] Validar métricas (latência, taxa de erro)
- [ ] Confirmar features funcionando
- [ ] Comunicar time

#### 5. Template de Saída
```markdown
===============================================================================
ETAPA 4: DEPLOY E VERSIONAMENTO COMPLETO
===============================================================================

RELEASE: v1.2.0

GIT:
- Commit: [hash]
- Branch: [nome]
- Tag: v1.2.0
- Push: [status]

DEPLOY:
- Estratégia: Feature Flag / Blue-Green / Canary
- Ambiente: [staging/production]
- Status: SUCESSO ✓

DOCUMENTAÇÃO:
- CHANGELOG: ✓
- README: ✓
- Variáveis de ambiente: ✓

COMUNICAÇÃO:
- Time notificado: ✓
- Anúncio preparado: ✓

OBSERVABILIDADE:
- Dashboards: Ativos
- Alertas: Configurados
- Logs: Estruturados

ROLLBACK:
- Plano: Documentado
- Testado: ✓
- Tempo estimado: [X minutos]

PRÓXIMOS PASSOS:
- Monitorar métricas por 24h
- Ativar feature flag gradualmente
- [outros]
===============================================================================
```

#### 6. Salvar Contexto
```bash
cat > acoes/temp/contexto_etapa_4.json << 'EOF'
{
  "etapa": 4,
  "concluida": true,
  "timestamp": "...",
  "release": {
    "versao": "1.2.0",
    "commit": "...",
    "branch": "...",
    "tag": "v1.2.0"
  },
  "deploy": {
    "estrategia": "...",
    "ambiente": "...",
    "status": "sucesso"
  },
  "documentacao_atualizada": true,
  "rollback": {...}
}
EOF
```

### Aprovação Esperada
**`DEPLOYADO`** (ou PUSH CONFIRMADO, PUBLICAR, OK)

### Workflow Completo
✅ **CONCLUÍDO**

---

## COMANDOS GLOBAIS (Disponíveis em Qualquer Etapa)

### `/status`
Mostra etapa atual, aprovadas e próxima recomendada.

**Exemplo de saída:**
```
📊 STATUS ATUAL

Etapas Concluídas: [0, 1, 2]
Etapa Atual: 3 (Testes e Validação)
Próxima Etapa: 4 (Deploy e Versionamento)

Aprovações Registradas:
✓ Etapa 0: ANALISADO (2025-11-09 10:30)
✓ Etapa 1: PLANEJADO (2025-11-09 11:15)
✓ Etapa 2: IMPLEMENTADO (2025-11-09 14:45)
⏳ Etapa 3: Aguardando VALIDADO

Contextos Salvos:
✓ contexto_etapa_0.json
✓ contexto_etapa_1.json
✓ contexto_etapa_2.json
```

### `/context`
Exibe snapshot resumido dos contextos.

```bash
cat acoes/temp/contexto_etapa_0.json | jq .
cat acoes/temp/contexto_etapa_1.json | jq .
# ...
```

### `/reset`
Remove arquivos de contexto (pede confirmação).

```bash
echo "⚠️  ATENÇÃO: Isso apagará TODO o contexto atual!"
echo "Tem certeza? (s/n)"
# Se confirmado:
rm -f acoes/temp/contexto_*.json
rm -f acoes/temp/sessao_atual.json
echo "✓ Contexto limpo. Reiniciando..."
```

### `/help`
Lista comandos e explica etapas.

### `/back`
Retorna ao menu principal sem alterar contexto.

### `/skip [n]`
Tenta pular para etapa n (com avisos de riscos).

```
⚠️  AVISO: Você está tentando pular da etapa 0 para a etapa 2
Etapas puladas: [1 - Planejamento]

RISCOS:
- Implementação sem plano estruturado
- Possível duplicação de código
- Feature flags não definidos
- Testes não planejados

Deseja continuar mesmo assim? (s/n)
```

---

## TRATAMENTO DE ERROS E FALLBACKS

### Entrada Inválida
```
❌ Opção inválida. Informe 0-4 ou comando (/help).
```

### Etapa Crítica Pulada
```
⚠️ Recomendação: executar Etapa [n] antes. Prosseguir? (s/n)
```

### Contexto Ausente/Corrompido
```
🔄 Contexto não encontrado. Use /reset ou forneça os dados novamente.
```

### Falha de Execução
```
❌ ERRO: [descrição do erro]

Detalhes: [stack trace ou logs]

Opções:
1. [R]etornar ao menu
2. [T]entar novamente
3. [A]bortar tarefa
```

---

## MÉTRICAS DE SUCESSO DO WORKFLOW

### Tempo
- Menu exibido em ≤ 1 mensagem
- Comandos respondem em ≤ 1 mensagem
- Usuário percorre 0→4 sem perder contexto

### Qualidade
- Cada etapa gera artefatos completos
- Aprovações registradas corretamente
- Contexto salvo em JSON válido
- Código sem duplicação (0% meta)
- Cobertura ≥ 85%
- Complexidade ≤ 10

### Rastreabilidade
- STATE sempre atualizado
- Logs estruturados
- Histórico de decisões preservado
- Rollback sempre disponível

---

## COMPATIBILIDADE

Este workflow funciona com:
- ✅ Claude Code
- ✅ GPT-4 / ChatGPT
- ✅ Google Gemini
- ✅ Codex
- ✅ Mistral
- ✅ Qualquer LLM que interprete Markdown

**Princípio**: Blueprint puro em Markdown/JSON, sem dependências de scripts ou ambiente.

---

**Engine Prompt Mestre v1.0** — Workflow Estruturado e Funcional
