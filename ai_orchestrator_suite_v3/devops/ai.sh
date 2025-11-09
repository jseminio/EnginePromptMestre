#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_FILE="${ROOT_DIR}/config/ai-config.yaml"
ROUTE_SCRIPT="${ROOT_DIR}/devops/route.sh"

read_config_value() {
  local key="$1"
  if [[ -f "${CONFIG_FILE}" ]]; then
    local value
    value=$(sed -n "s/^${key}:[[:space:]]*//p" "${CONFIG_FILE}" | head -n 1 | sed 's/^"//;s/"$//')
    printf '%s' "${value}"
  else
    printf '%s' ""
  fi
}

DEFAULT_ENGINE="$(read_config_value "engine")"
DEFAULT_HISTORY="$(read_config_value "history_policy")"
DEFAULT_DECISION="$(read_config_value "decision_mode")"
DEFAULT_ENGINE="${DEFAULT_ENGINE:-auto}"
DEFAULT_HISTORY="${DEFAULT_HISTORY:-strict}"
DEFAULT_DECISION="${DEFAULT_DECISION:-DE ACORDO}"

usage() {
  cat <<USAGE
Uso: $(basename "$0") <comando> [opções]

Comandos:
  init                       Prepara scripts, permissões e diretórios.
  run <agente> <task> [--opções]  Executa agente via roteador multi-IA.

Opções para 'run':
  --engine=<engine>          codex|claude|gemini|ab|abc|auto
  --history=<policy>         strict|ignore
  --decision=<modo>          "DE ACORDO"|AUTOMÁTICO
  --extra "<texto>"          contexto adicional enviado à CLI
USAGE
}

if [[ $# -lt 1 ]]; then
  usage
  exit 64
fi

COMMAND="$1"
shift

case "${COMMAND}" in
  init)
    mkdir -p "${ROOT_DIR}/.runs" "${ROOT_DIR}/.devops"
    chmod +x "${ROOT_DIR}/devops"/*.sh
    if [[ ! -f "${CONFIG_FILE}" ]]; then
      echo "Arquivo de configuração não encontrado em ${CONFIG_FILE}." >&2
    fi
    echo "AI Orchestrator Suite v3 inicializado. Engine padrão: ${DEFAULT_ENGINE}."
    ;;
  run)
    if [[ $# -lt 2 ]]; then
      echo "Informe agente e task." >&2
      usage
      exit 64
    fi
    AGENT="$1"
    TASK="$2"
    shift 2

    ENGINE="${DEFAULT_ENGINE}"
    HISTORY="${DEFAULT_HISTORY}"
    DECISION="${DEFAULT_DECISION}"
    EXTRA_CONTEXT=""
    POSITIONAL=()

    while [[ $# -gt 0 ]]; do
      case "$1" in
        --engine=*) ENGINE="${1#*=}"; shift ;;
        --history=*) HISTORY="${1#*=}"; shift ;;
        --decision=*) DECISION="${1#*=}"; shift ;;
        --extra)
          shift
          EXTRA_CONTEXT="${1:-}"
          if [[ $# -gt 0 ]]; then shift; fi
          ;;
        *)
          POSITIONAL+=("$1")
          shift
          ;;
      esac
    done

    export DECISION_MODE="${DECISION}"
    export HISTORY_POLICY="${HISTORY}"

    if [[ -n "${EXTRA_CONTEXT}" ]]; then
      POSITIONAL+=("--context" "${EXTRA_CONTEXT}")
    fi

    if [[ ! -x "${ROUTE_SCRIPT}" ]]; then
      echo "Roteador não encontrado em ${ROUTE_SCRIPT}." >&2
      exit 126
    fi

    "${ROUTE_SCRIPT}" --engine="${ENGINE}" --history="${HISTORY}" --decision="${DECISION}" -- "run" "${AGENT}" "${TASK}" "${POSITIONAL[@]}"
    ;;
  *)
    echo "Comando '${COMMAND}' não reconhecido." >&2
    usage
    exit 64
    ;;
esac
