# Políticas Obrigatórias P1–P6 — Engine Prompt Mestre

Estas políticas valem para **todos os agentes e prompts** deste repositório. Sempre confirme o reuso antes de propor mudanças e mantenha os registros atualizados.

## P1 — Reuso e Verificação
- Inventarie rapidamente os artefatos existentes antes de propor novidades.
- Registre explicitamente o que será reutilizado e como foi validado.
- Marque `pendente_validacao` quando faltar evidência e solicite confirmação.

## P2 — Planejamento com Linhas/Âncoras
- Nos planos, aponte caminhos completos e âncoras (nº de linhas ou trechos distintos) para cada alteração.
- Destaque comandos e artefatos em formato de lista enxuta para facilitar a execução sequencial.
- Atualize o planejamento se novas evidências alterarem as âncoras previstas.

## P3 — Implementação e Log
- Execute mudanças via diffs curtos (`patch`) e registre comandos, saídas e feature flags usados.
- Guarde logs de teste/execução no contexto ou resposta final, sem suprimir erros relevantes.
- Certifique-se de que cada alteração tenha rollback documentado ou caminho de reversão claro.

## P4 — Token Saving
- Reutilize respostas anteriores e documentos existentes em vez de reescrever conteúdo.
- Prefira referências compactas (links relativos, âncoras, IDs) e evite repetir trechos longos.
- Mantenha respostas objetivas, destacando apenas o essencial para a próxima ação.

## P5 — Clear Code + Arquivos Pequenos
- Produza código/artefatos claros, modulares e com responsabilidades isoladas.
- Limite o tamanho dos arquivos e utilize chunking por seções quando inevitável.
- Nunca sobrescreva arquivos inteiros; aplique apenas deltas focados.

## P6 — Conhecimento do Projeto como Fonte de Verdade
- Priorize sempre a documentação e os artefatos do projeto como base das decisões.
- Sincronize descobertas relevantes nos arquivos de contexto (`acoes/temp/*.json`).
- Caso alguma informação esteja ausente, sinalize `pendente_validacao` e solicite dados ao usuário/time.
