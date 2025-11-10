# 🧪 Orchestrator Smoke Suite

Guia rápido para validar o fluxo 0→4 após qualquer alteração nos blueprints ou feature flags.

## Pré-condições
- Contextos `acoes/temp/contexto_etapa_{0,1}.json` atualizados
- Variáveis de ambiente opcionais:
  - `FEATURE_CONTEXT_GUARD=true` para validar persistência
  - `FEATURE_MENU_TELEMETRIA=true` para exibir métricas no menu

## 1. Guardião de Contexto (unitário)
```bash
FEATURE_CONTEXT_GUARD=true \
EnginePromptMestre/scripts/context_guard.sh --file acoes/temp/contexto_etapa_1.json --force
EnginePromptMestre/scripts/context_guard.sh --file acoes/temp/sessao_atual.json --force
```
**Validações**
- Saída `[context_guard][INFO] JSON valido ...`
- Arquivos novos em `acoes/temp/backups/`

## 2. Renderização do Menu Único (integração)
```bash
bash tests/orchestrator_menu.sh
```
**Verificar**
- Cabeçalho "🤖 Orquestrador Fullstack v2.4" aparece uma única vez
- Bloco de status reflete `sessao_atual.json`

## 3. Fluxo Legacy sem flags (regressão)
```bash
bash tests/legacy_flow.sh
```
**Esperado**
- Com `FEATURE_*` padrão (False) o fluxo 0→4 continua funcional
- Nenhum backup extra criado

## 4. Observabilidade
```bash
time -p bash start_orchestrator.sh
```
**Meta**: menu renderizado em ≤ 1s.

> Documente as evidências em `acoes/temp/contexto_etapa_2.json` ao finalizar a Etapa 2.
