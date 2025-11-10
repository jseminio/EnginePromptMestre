# 📚 Catálogo de Análises e Reuso

Este documento registra todo o conhecimento acumulado sobre o projeto: componentes existentes, padrões aprovados, dívidas técnicas e decisões de reuso. **Sempre atualize este arquivo** ao concluir uma evolução, manutenção ou exclusão relevante. Ele é a referência única para que qualquer agente encontre rapidamente o que já foi feito antes de propor algo novo.

## Como atualizar
1. Localize a seção do domínio impactado (Backend, Frontend, Banco, etc.).
2. Registre:
   - **Contexto**: qual tarefa/etapa originou a mudança (link para `tasks/<id>.md`).
   - **Componentes Reutilizáveis**: módulos, serviços, APIs, jobs, scripts.
   - **Dependências/Riscos**: feature flags, integrações externas, dados sensíveis.
   - **Status**: ativo, legado, em migração, depreciado.
3. Se algo for removido ou substituído, marque explicitamente como `DEPRECATED` e informe o substituto.

## Seções sugeridas
- Backend
- Frontend
- Banco de Dados / DBA
- UX & Conteúdo
- Observabilidade / SRE
- QA & Métricas
- Anexos (diagramas, links externos)

> Dica: mantenha entradas curtas e objetivas para economizar tokens nas próximas consultas.
