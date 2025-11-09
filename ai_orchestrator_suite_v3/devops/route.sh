#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RESUME_FILE="${ROOT_DIR}/.devops/resume_task.md"
ENGINE="${ENGINE:-auto}"
HISTORY_POLICY="${HISTORY_POLICY:-strict}"
DECISION_MODE="${DECISION_MODE:-DE ACORDO}"

ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --engine=*) ENGINE="${1#*=}"; shift ;;
    --history=*) HISTORY_POLICY="${1#*=}"; shift ;;
    --decision=*) DECISION_MODE="${1#*=}"; shift ;;
    --)
      shift
      while [[ $# -gt 0 ]]; do
        ARGS+=("$1")
        shift
      done
      ;;
    *)
      ARGS+=("$1")
      shift
      ;;
  esac
done

export DECISION_MODE
export HISTORY_POLICY

if [[ "${HISTORY_POLICY}" == "ignore" ]]; then
  TIMESTAMP="$(date -u +"%Y%m%dT%H%M%SZ")"
  BACKUP_FILE="${RESUME_FILE}.bak-${TIMESTAMP}"
  if [[ -f "${RESUME_FILE}" ]]; then
    cp "${RESUME_FILE}" "${BACKUP_FILE}"
  fi
  : > "${RESUME_FILE}"
fi

require_confirmation() {
  local stage="$1"
  if [[ "${DECISION_MODE}" == "DE ACORDO" ]]; then
    if [[ -t 0 ]]; then
      echo "Resumo da etapa: ${stage}"
      read -rp "Digite 'DE ACORDO' para prosseguir: " response
      if [[ "${response}" != "DE ACORDO" ]]; then
        echo "Execução interrompida por falta de confirmação." >&2
        exit 130
      fi
    else
      echo "Modo DE ACORDO requer confirmação interativa (stdin não é TTY)." >&2
      exit 130
    fi
  fi
}

execute_engine() {
  local engine_name="$1"
  shift || true
  local script_path="${ROOT_DIR}/devops/run_${engine_name}.sh"
  if [[ ! -x "${script_path}" ]]; then
    echo "Script ${script_path} não encontrado ou sem permissão de execução." >&2
    exit 126
  fi
  require_confirmation "${engine_name}"
  "${script_path}" "$@"
}

run_chain() {
  local -a chain=("$@")
  local exit_code=1
  for engine_name in "${chain[@]}"; do
    if execute_engine "${engine_name}" "${ARGS[@]}"; then
      exit_code=0
      break
    else
      exit_code=$?
      echo "Engine ${engine_name} falhou com código ${exit_code}. Tentando próximo..." >&2
    fi
  done
  return ${exit_code}
}

case "${ENGINE}" in
  codex|claude|gemini)
    execute_engine "${ENGINE}" "${ARGS[@]}"
    ;;
  ab)
    run_chain codex claude
    ;;
  abc|auto)
    run_chain codex claude gemini
    ;;
  *)
    echo "ENGINE '${ENGINE}' não suportado." >&2
    exit 64
    ;;
esac
