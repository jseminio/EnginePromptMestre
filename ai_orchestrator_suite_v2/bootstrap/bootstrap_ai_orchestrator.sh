#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
DEFAULT_TARGET="$(pwd)"
TARGET_DIR="${TARGET_DIR:-${DEFAULT_TARGET}}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target=*) TARGET_DIR="${1#*=}"; shift ;;
    *) TARGET_DIR="$1"; shift ;;
  esac
done

OS_NAME=$(uname -s 2>/dev/null || echo "Desconhecido")
case "${OS_NAME}" in
  Linux*) PLATFORM="Linux/Rocky" ;;
  Darwin*) PLATFORM="macOS" ;;
  CYGWIN*|MINGW*|MSYS*) PLATFORM="Windows" ;;
  *) PLATFORM="Desconhecido" ;;
esac

echo "Detectado sistema: ${PLATFORM} (${OS_NAME})"

DESTINATION="${TARGET_DIR%/}/ai_orchestrator_suite_v2"
if [[ "${TEMPLATE_ROOT}" == "${DESTINATION}" ]]; then
  echo "Template já está no destino (${DESTINATION}). Nenhuma cópia necessária."
  exit 0
fi

if [[ -d "${DESTINATION}" ]]; then
  echo "Estrutura já existente em ${DESTINATION}. Nenhuma ação necessária."
else
  mkdir -p "${TARGET_DIR}"
  cp -R "${TEMPLATE_ROOT}" "${DESTINATION}"
  chmod +x "${DESTINATION}/devops"/*.sh
  echo "Estrutura criada em ${DESTINATION}."
fi

echo "Próximos passos:"
echo "  1. cd ${TARGET_DIR}"
echo "  2. ./ai_orchestrator_suite_v2/devops/ai.sh init (ou .\\ai.ps1 init no Windows)"
echo "  3. Configure config/ai-config.yaml conforme necessário."
