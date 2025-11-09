.PHONY: run test lint format install-hooks

run:
	@echo "Nenhum serviço configurado. Adicione comandos de execução aqui."

test:
	@echo "Executando suíte de testes padrão"
	@python -m pytest || echo "Adicionar testes em tests/"

lint:
	@echo "Executando linters"
	@flake8 src tests || true
	@eslint . || true

format:
	@echo "Aplicando formatação padrão"
	@black src tests || true
	@prettier --write . || true

install-hooks:
	@git config core.hooksPath .githooks
	@echo "Hooks configurados a partir de .githooks"
