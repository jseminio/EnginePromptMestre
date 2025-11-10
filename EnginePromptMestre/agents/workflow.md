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


## Política de Reuso 80/20

> Antes de propor qualquer arquivo/componente novo, confirme se existe algo que cubra pelo menos 80% da necessidade. Caso exista, evolua o artefato existente com clean code/feature flags e registre no contexto; somente crie algo totalmente novo quando justificar explicitamente a impossibilidade de reuso.
---

## ETAPAS 0→3 (PROCESSO OPERACIONAL)

> Cada etapa possui o template correspondente em `acoes/etapa_[n].md`. Use-o como checklist completo e registre sempre no JSON indicado.

### Etapa 0 — Análise Contextual
- **Entradas**: briefing do usuário, stack detectada, restrições.
- **Passos**: inventariar estrutura (`tree`, `rg`), identificar reuso, dependências, riscos e métricas base.
- **Saída**: relatório estruturado + `acoes/temp/contexto_etapa_0.json` preenchido via guardião.
- **Agentes**: Orquestrador (consulta DBA/UX apenas se necessário).

### Etapa 1 — Planejamento
- **Entradas**: contexto da etapa 0.
- **Passos**: objetivos mensuráveis, estratégia de entrega, artefatos (criar/modificar/ler), mapa de reuso, feature flags, plano de testes e métricas.
- **Saída**: plano completo + `acoes/temp/contexto_etapa_1.json` (com objetivos, fases, gates, testes).
- **Agentes**: Arquiteto (principal) + especialistas requisitados pelo orquestrador.

### Etapa 2 — Implementação
- **Entradas**: contextos 0 e 1.
- **Passos**: seguir as 5 fases (preparação, core, testes, evidências, documentação), sempre reutilizando componentes catalogados e mantendo feature flags em `False` por padrão.
- **Saída**: código/testes/documentação atualizados + `acoes/temp/contexto_etapa_2.json` descrevendo arquivos, flags, validações e rollback.
- **Agentes**: Backend → Frontend → DBA → UX (ordem definida pelo orquestrador).

### Etapa 3 — Testes e Validação
- **Entradas**: contextos 0, 1 e 2.
- **Passos**: executar suíte de testes (unitário, integração, regressão, performance, segurança), medir cobertura/complexidade/duplicação, registrar métricas e evidências.
- **Saída**: `acoes/temp/contexto_etapa_3.json` com resultados e quality gate aprovado.
- **Agentes**: QA conduz, envolvendo times técnicos apenas para correções.

> Todas as etapas compartilham o mesmo fluxo de persistência: carregar contextos existentes, aplicar `context_guard`, produzir entregáveis, salvar JSON, atualizar `acoes/temp/sessao_atual.json` e aguardar a palavra-chave da etapa.


## ETAPA 4 — DEPLOY E VERSIONAMENTO

- **Entradas**: todos os contextos (0→3) + decisão de release.
- **Passos essenciais**:
  1. Preparar pacote (CHANGELOG, README, instruções de ativação/rollback).
  2. Validar git (status limpo, commit/tag/push aprovados).
  3. Executar estratégia de deploy (Feature Flag, Blue-Green ou Canary) com checklist pré/pós.
  4. Atualizar `acoes/temp/contexto_etapa_4.json` com release, estratégia, métricas e rollback documentado.
  5. Comunicar stakeholders (UX / time de produto) e monitorar métricas/alertas.
- **Agentes**: SRE lidera, UX comunica e monitora mensagens.
- **Saída padrão**: release documentado, dashboards/alertas ativos e plano de rollback validado.

> Utilize o template `acoes/etapa_4_deploy_versionamento.md` para registrar o passo a passo; mantenha scripts git/deploy externos referenciados, sem duplicá-los aqui.


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
