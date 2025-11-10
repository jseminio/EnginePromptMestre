# 📦 Pasta de Contexto Temporário

## Propósito

Esta pasta armazena o contexto entre etapas do workflow.

## Arquivos Gerados

- `sessao_atual.json` - Estado da sessão atual
- `contexto_etapa_0.json` - Dados da análise
- `contexto_etapa_1.json` - Dados do planejamento
- `contexto_etapa_2.json` - Dados da implementação
- `contexto_etapa_3.json` - Dados da validação
- `contexto_etapa_4.json` - Dados do deploy
- `context_schema.json` - Schema leve usado pelos validadores
- `backups/*.json` - Snapshots versionados automaticamente

## Como Funciona

1. Cada etapa **SALVA** seu contexto ao finalizar
2. A próxima etapa **CARREGA** automaticamente o contexto
3. O assistente usa `cat` para ler e `echo` para escrever

## Guardião + Backups

- Ative `FEATURE_CONTEXT_GUARD=true` para rodar automaticamente:
  ```bash
  EnginePromptMestre/scripts/context_guard.sh --file acoes/temp/contexto_etapa_1.json
  EnginePromptMestre/scripts/context_guard.sh --file acoes/temp/sessao_atual.json
  ```
- O script valida o JSON (estrutura mínima, tipos básicos) usando `context_schema.json`, grava um backup em `temp/backups/` e mantém apenas as últimas 5 versões por arquivo.
- Use `--force` para executar manualmente mesmo com a flag desligada.

## Limpeza

Para iniciar uma nova sessão:
```bash
rm -f acoes/temp/contexto_*.json
rm -f acoes/temp/sessao_atual.json
rm -f acoes/temp/backups/*.json
```

## Compatibilidade

✅ Funciona com qualquer LLM que possa executar comandos shell
✅ JSON para máxima compatibilidade
✅ Fallback para Markdown se JSON falhar (registros rápidos em `temp/README.md` antes de revalidar)
