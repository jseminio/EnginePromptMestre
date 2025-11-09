# Regras de Qualidade e Testes

## Portão de Qualidade
- Cobertura mínima: 85% (unit + integration).
- Complexidade ciclomática máxima por função: 10.
- Zero falhas críticas abertas nos relatórios de QA.

## Checklist Automático
1. Executar `python manage.py test` ou equivalente backend.
2. Rodar `npm run test` e `npm run lint` no frontend.
3. Verificar segurança com `bandit -r` e `npm audit --production`.
4. Validar infraestrutura com `terraform fmt -check` e `terraform validate` (se aplicável).
5. Consolidar métricas e anexar em `.runs/<engine>/latest.log`.

## Checklist Manual
- Revisar SPEC e ADR atualizados.
- Confirmar plano de rollback atualizado e testado.
- Garantir que `STATE` inclua próxima ação e itens pendentes.
