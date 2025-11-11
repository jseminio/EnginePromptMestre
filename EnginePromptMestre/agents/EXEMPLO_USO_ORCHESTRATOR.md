# Exemplo de Uso do Orquestrador

> Este roteiro segue obrigatoriamente as políticas [P1–P6](./politicas.md) (reuso verificado, âncoras claras, diffs/logs mínimos, economia de tokens, arquivos curtos e fontes oficiais).

## Cenário 1: Primeira Vez (Sem Contexto Anterior)

### Comando do Usuário:
```bash
inicie EnginePromptMestre/agents/orchestrator.md
```

### Comportamento Esperado do LLM:

**1. Executa automaticamente** (SEM pausar):
```bash
if [ -f acoes/temp/sessao_atual.json ]; then
  cat acoes/temp/sessao_atual.json
else
  echo "{}"
fi
```

**Resultado**: `{}`

**2. Apresenta menu imediatamente**:
```
🤖 Orquestrador Fullstack v2.4 — Sistema Inicializado

Projeto: EnginePromptMestre
Stack: Python 3.11, Django 5.1, Vue 3, Quasar
Branch: pm001

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📍 Status: Nenhuma etapa iniciada | Contexto: limpo
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ETAPAS DISPONÍVEIS (Recomendado: 0→1→2→3→4):

[0] 📊 Análise Contextual + Antialucinação
    └─ Output: Inventário de reuso + Evidências + Riscos
    └─ Status: ⚪ Não iniciada

[1] 📌 Planejamento (Reuso-Primeiro + Gates)
    └─ Output: Plano completo + Arquivos + Testes + Feature gates
    └─ Status: ⚪ Não iniciada (depende da Etapa 0)

[2] 🧱 Implementação Controlada
    └─ Output: Código + Logs + Backward compatibility
    └─ Status: ⚪ Não iniciada (depende da Etapa 1 aprovada)

[3] ✅ Testes, Validação e Métricas
    └─ Output: LOC/Rotas/Duplicação + Testes passando
    └─ Status: ⚪ Não iniciada

[4] 🚀 Deploy, Versionamento e CHANGELOG
    └─ Output: Git commit + Documentação atualizada
    └─ Status: ⚪ Não iniciada

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
COMANDOS ESPECIAIS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/status    → Ver progresso e próxima etapa recomendada
/context   → Exibir contexto atual (ler arquivos temp/)
/reset     → Limpar contexto e reiniciar fluxo
/help      → Ajuda detalhada sobre cada etapa
/back      → Voltar para este menu principal
/skip [n]  → Pular para etapa n (com aviso de riscos)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 Dica: Siga a ordem sequencial (0→4) para melhor qualidade
💡 Contexto salvo automaticamente em acoes/temp/

Digite o número da etapa (0-4) ou comando:
```

**3. Aguarda escolha do usuário**

---

## Cenário 2: Retomando Sessão Anterior

### Comando do Usuário:
```bash
inicie EnginePromptMestre/agents/orchestrator.md
```

### Comportamento Esperado do LLM:

**1. Executa automaticamente**:
```bash
if [ -f acoes/temp/sessao_atual.json ]; then
  cat acoes/temp/sessao_atual.json
else
  echo "{}"
fi
```

**Resultado**:
```json
{
  "etapa_atual": 1,
  "etapa_concluida": false,
  "proxima_etapa": 1,
  "timestamp": "2025-11-09T20:00:00Z",
  "etapas_concluidas": [0]
}
```

**2. Detecta sessão anterior e pergunta**:
```
📋 Sessão anterior detectada:
   - Etapa atual: 1 (Planejamento)
   - Etapas concluídas: [0]
   - Última atualização: 2025-11-09T20:00:00Z

Deseja continuar de onde parou? (s/n)
```

**3a. Se usuário responder "s"**:
- Carregar contexto da etapa 1
- Continuar execução

**3b. Se usuário responder "n"**:
- Apresentar menu completo (novo início)

---

## ❌ Comportamento INCORRETO (NÃO fazer)

### Errado 1: Pausar antes de executar
```
❌ "Vou verificar o contexto..."
   [pausa esperando aprovação do usuário]
```

**Correto**: Executar imediatamente sem pausar

### Errado 2: Não executar o comando
```
❌ Apresentar menu sem verificar contexto
```

**Correto**: Sempre verificar contexto primeiro

### Errado 3: Pedir múltiplas confirmações
```
❌ "Posso executar o comando bash?"
   "Posso apresentar o menu?"
```

**Correto**: Executar tudo automaticamente

---

## ✅ Fluxo Correto Resumido

```
Usuário: inicie orchestrator.md
    ↓
LLM: [EXECUTA bash automaticamente]
    ↓
LLM: [VERIFICA resultado]
    ↓
├─ Se {} → [APRESENTA MENU]
└─ Se JSON → [PERGUNTA se continua]
    ↓
LLM: [AGUARDA escolha do usuário]
```

**Sem pausas desnecessárias!**

---

## 🎯 Regras de Ouro

1. ✅ **Executar** comandos bash IMEDIATAMENTE
2. ✅ **Verificar** contexto SEMPRE
3. ✅ **Perguntar** sobre continuar APENAS se houver sessão anterior
4. ✅ **Apresentar** menu automaticamente se sessão nova
5. ❌ **NÃO pausar** antes de executar verificações
6. ❌ **NÃO pedir** múltiplas confirmações

---

**Versão**: 1.0
**Engine Prompt Mestre** — Comportamento Esperado do Orquestrador
