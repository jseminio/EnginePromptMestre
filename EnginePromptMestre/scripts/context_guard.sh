#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
context_guard.sh --file <caminho> [--force]

Valida JSON de contexto/sessao contra o schema leve em promptmestre/temp/context_schema.json,
cria backup versionado e registra logs pro orquestrador.

Opcoes:
  -f, --file <caminho>   Arquivo JSON a validar (obrigatorio)
      --force            Ignora FEATURE_CONTEXT_GUARD e executa mesmo assim
  -h, --help             Mostra esta mensagem

Variaveis de ambiente:
  FEATURE_CONTEXT_GUARD  Flag para habilitar o guard (default: false)
  SCHEMA_PATH            Caminho alternativo para o schema
  BACKUP_DIR             Pasta de backups (default: promptmestre/temp/backups)
USAGE
}

log() {
  local level="$1"; shift
  printf '[context_guard][%s] %s\n' "$level" "$*"
}

command -v jq >/dev/null 2>&1 || { echo "jq nao encontrado" >&2; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo "python3 nao encontrado" >&2; exit 1; }

SCHEMA_PATH=${SCHEMA_PATH:-promptmestre/temp/context_schema.json}
BACKUP_DIR=${BACKUP_DIR:-promptmestre/temp/backups}
FLAG=${FEATURE_CONTEXT_GUARD:-false}
FORCE=false
TARGET_FILE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--file)
      if [[ $# -lt 2 ]]; then
        echo "--file requer um caminho" >&2
        exit 1
      fi
      TARGET_FILE="$2"
      shift 2
      continue
      ;;
    --force)
      FORCE=true
      shift
      continue
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Argumento desconhecido: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$TARGET_FILE" ]]; then
  echo "--file e obrigatorio" >&2
  usage
  exit 1
fi

if [[ ! -f "$TARGET_FILE" ]]; then
  echo "Arquivo nao encontrado: $TARGET_FILE" >&2
  exit 1
fi

filename=$(basename "$TARGET_FILE")
extension=""
if [[ "$filename" == *.* ]]; then
  extension="${filename##*.}"
fi
if [[ "$extension" != "json" && "$extension" != "md" ]]; then
  if [[ -t 0 ]]; then
    read -r -p "Extensao .$extension detectada em $filename. Qual tipo de arquivo deseja gerar? " file_type_input
    read -r -p "Informe o motivo para gerar esse arquivo: " file_reason_input
  else
    file_type_input=${FILE_TYPE_OVERRIDE:-"nao informado"}
    file_reason_input=${FILE_REASON_OVERRIDE:-"motivo nao informado"}
  fi
  log "INFO" "Extensao .$extension -> tipo informado: ${file_type_input:-desconhecido} | motivo: ${file_reason_input:-nao informado}"
fi

if [[ "$FLAG" != "true" && "$FORCE" != "true" ]]; then
  log "INFO" "FEATURE_CONTEXT_GUARD desabilitada. Nada a fazer para $TARGET_FILE"
  exit 0
fi

if [[ ! -f "$SCHEMA_PATH" ]]; then
  echo "Schema nao encontrado em $SCHEMA_PATH" >&2
  exit 1
fi

log "INFO" "Validando $TARGET_FILE com schema $SCHEMA_PATH"

if ! jq empty "$TARGET_FILE" >/dev/null 2>&1; then
  log "ERROR" "JSON invalido em $TARGET_FILE"
  exit 1
fi

type_hint="contexto"
if grep -qi "sessao" <<< "$filename"; then
  type_hint="sessao"
else
  if jq -e 'has("etapa_atual")' "$TARGET_FILE" >/dev/null 2>&1; then
    type_hint="sessao"
  fi
fi

VALIDATION_SCRIPT=$(cat <<'PY'
import json, sys, pathlib
file_path = pathlib.Path(sys.argv[1])
schema_path = pathlib.Path(sys.argv[2])
target = sys.argv[3]

data = json.loads(file_path.read_text())
schema = json.loads(schema_path.read_text())
section = schema.get(target)
if section is None:
    print(f"Sessao {target} nao definida no schema", file=sys.stderr)
    sys.exit(1)
missing = [key for key in section.get("required", []) if key not in data]
if missing:
    print(f"Campos obrigatorios ausentes: {', '.join(missing)}", file=sys.stderr)
    sys.exit(1)
errors = []
for key in section.get("numeric", []):
    if key in data and not (isinstance(data[key], int) and not isinstance(data[key], bool)):
        errors.append(f"Campo '{key}' deve ser inteiro")
for key in section.get("boolean", []):
    if key in data and not isinstance(data[key], bool):
        errors.append(f"Campo '{key}' deve ser booleano")
for key in section.get("string", []):
    if key in data and not isinstance(data[key], str):
        errors.append(f"Campo '{key}' deve ser string")
if errors:
    for err in errors:
        print(err, file=sys.stderr)
    sys.exit(1)
missing_recommended = [key for key in section.get("recommended", []) if key not in data]
if missing_recommended:
    print("Aviso: campos recomendados ausentes -> " + ', '.join(missing_recommended))
PY
)

if ! python3 -c "$VALIDATION_SCRIPT" "$TARGET_FILE" "$SCHEMA_PATH" "$type_hint"; then
  log "ERROR" "Falha na validacao semantica"
  exit 1
fi

log "INFO" "JSON valido e com campos obrigatorios presentes"

mkdir -p "$BACKUP_DIR"
timestamp_format=$(jq -r '.backup.timestamp_format // "%Y%m%dT%H%M%SZ"' "$SCHEMA_PATH")
retencao=$(jq -r '.backup.retencao // 5' "$SCHEMA_PATH")
timestamp=$(date -u +"$timestamp_format")
backup_file="$BACKUP_DIR/$(basename "$TARGET_FILE").$timestamp.json"
cp "$TARGET_FILE" "$backup_file"
log "INFO" "Backup criado em $backup_file"

pattern="$BACKUP_DIR/$(basename "$TARGET_FILE")."
mapfile -t backups < <(ls -1t ${pattern}* 2>/dev/null || true)
if [[ ${#backups[@]} -gt $retencao ]]; then
  for old in "${backups[@]:$retencao}"; do
    rm -f "$old"
    log "INFO" "Backup antigo removido: $old"
  done
fi

log "INFO" "context_guard concluido com sucesso."
