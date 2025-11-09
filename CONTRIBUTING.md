# Guia de Contribuição

## Fluxo de trabalho
1. Crie um branch a partir de `main` com um nome descritivo.
2. Garanta que alterações estejam cobertas por testes quando aplicável.
3. Execute `make lint` e `make test` antes de enviar o código para revisão.
4. Abra um Pull Request descrevendo objetivo, evidências e dependências.

## Convenções de commit
- Formato: `:emoji: Resumo curto em português` (ex.: `✅ Ajusta fluxo de build`).
- Commits devem focar em um único escopo por vez.

## Revisões de código
- Utilize comentários claros, sugerindo melhorias específicas.
- Garanta que o PR contenha capturas de tela quando houver mudanças visuais.
- Respeite o checklist: testes, lint, documentação atualizada.

## Hooks e automações
- Configure `git config core.hooksPath .githooks` para habilitar os hooks locais.
- Hooks executam `make lint` e `make test` para evitar regressões.

## Estilo de código
- Python segue PEP 8 (ver `.flake8`).
- JavaScript/TypeScript segue regras do ESLint (ver `.eslintrc.json`).
- Formatação padronizada via Prettier (`.prettierrc`).

## Contato
Abra uma issue com dúvidas ou sugestões e descreva o contexto do problema.
