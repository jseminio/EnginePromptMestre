# Fluxo de Análise — Engine Prompt Mestre

1. Ler `acoes/temp/sessao_atual.json || echo "{}"` antes de qualquer ação.
2. Aplicar P1 e P6: inventariar reuso e validar informações com artefatos existentes.
3. Mapear âncoras relevantes (arquivos + linhas) para alimentar o planejamento (P2).
4. Registrar achados em `acoes/temp/contexto_etapa_0.json` usando `scripts/context_guard.sh`.
