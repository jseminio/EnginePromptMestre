#!/usr/bin/env bash
set -euo pipefail

CLI_NAME="gemini"
LOG_DIR="$(dirname "$0")/../logs"
ENV_FILE="$(dirname "$0")/../config/${CLI_NAME}.env"
SESSION_FILE="${LOG_DIR}/sessao_${CLI_NAME}_$(date +%Y%m%d).md"

mkdir -p "$LOG_DIR"

if [ -f "$ENV_FILE" ]; then
  echo "Carregando variáveis de ${ENV_FILE}"
  set -a
  # shellcheck disable=SC1090
  source "$ENV_FILE"
  set +a
else
  echo "Arquivo ${ENV_FILE} não encontrado. Prosseguindo com variáveis padrão."
fi

if [ ! -f "$SESSION_FILE" ]; then
  cat > "$SESSION_FILE" <<EOT
# Sessão ${CLI_NAME^} - $(date +%Y-%m-%d)

## Contexto
- Operador: $(whoami)
- Ambiente: ${ENVIRONMENT:-desconhecido}

## Eventos
EOT
fi

echo "- $(date +%H:%M:%S) Sessão iniciada" >> "$SESSION_FILE"

echo "Sessão ${CLI_NAME^} registrada em $SESSION_FILE"
