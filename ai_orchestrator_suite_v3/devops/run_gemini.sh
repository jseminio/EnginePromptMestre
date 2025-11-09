#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENGINE="gemini"
LOG_DIR="${ROOT_DIR}/.runs/${ENGINE}"
RESUME_FILE="${ROOT_DIR}/.devops/resume_task.md"
CLI_BIN="${GEMINI_CLI:-gemini}"
mkdir -p "${LOG_DIR}"

TIMESTAMP="$(date -u +"%Y%m%dT%H%M%SZ")"
LOG_FILE="${LOG_DIR}/${TIMESTAMP}.log"
COMMAND_ARGS=("$@")

{
  echo "# ${TIMESTAMP} — Execução Gemini"
  echo "CLI: ${CLI_BIN}"
  echo "Args: ${COMMAND_ARGS[*]:-<nenhum>}"
} >> "${LOG_FILE}"

STATUS="sucesso"
EXIT_CODE=0

if command -v "${CLI_BIN}" >/dev/null 2>&1; then
  set +e
  "${CLI_BIN}" "${COMMAND_ARGS[@]}" | tee -a "${LOG_FILE}"
  EXIT_CODE=$?
  set -e
  if [[ ${EXIT_CODE} -ne 0 ]]; then
    STATUS="falha (${EXIT_CODE})"
  fi
else
  MSG="CLI ${CLI_BIN} não encontrada no PATH."
  echo "${MSG}" | tee -a "${LOG_FILE}"
  STATUS="falha (CLI ausente)"
  EXIT_CODE=127
fi

cat >> "${RESUME_FILE}" <<RESUME
## ${TIMESTAMP}
- engine: ${ENGINE}
- decision_mode: ${DECISION_MODE:-desconhecido}
- history_policy: ${HISTORY_POLICY:-desconhecida}
- comando: ${CLI_BIN} ${COMMAND_ARGS[*]:-<nenhum>}
- status: ${STATUS}
RESUME

exit ${EXIT_CODE}
