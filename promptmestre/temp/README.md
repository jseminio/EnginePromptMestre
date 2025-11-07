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

## Como Funciona

1. Cada etapa **SALVA** seu contexto ao finalizar
2. A próxima etapa **CARREGA** automaticamente o contexto
3. O assistente usa `cat` para ler e `echo` para escrever

## Limpeza

Para iniciar uma nova sessão:
```bash
rm -f prompt_mestre/temp/contexto_*.json
rm -f prompt_mestre/temp/sessao_atual.json
```

## Compatibilidade

✅ Funciona com qualquer LLM que possa executar comandos shell
✅ JSON para máxima compatibilidade
✅ Fallback para Markdown se JSON falhar
