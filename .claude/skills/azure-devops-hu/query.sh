#!/bin/bash
# Consulta work items de Azure DevOps (Linktic / 355- Positiva Core) vía WIQL.
# Requiere AZDO_PAT, AZDO_ORG, AZDO_PROJECT en el entorno (ver ~/.zshrc).
#
# Uso:
#   query.sh                        -> mis work items activos (no Closed), resumen
#   query.sh <wiql>                 -> WIQL custom, ej: "... WHERE [System.State] = 'Active'"
#   query.sh --ids 123,456          -> detalle completo de esos IDs

set -euo pipefail

if [ -z "${AZDO_PAT:-}" ] || [ -z "${AZDO_ORG:-}" ] || [ -z "${AZDO_PROJECT:-}" ]; then
  echo "Faltan AZDO_PAT / AZDO_ORG / AZDO_PROJECT en el entorno. Corre: source ~/.zshrc" >&2
  exit 1
fi

ORG_ENC=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$AZDO_ORG")
PROJECT_ENC=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$AZDO_PROJECT")
BASE_URL="https://dev.azure.com/${ORG_ENC}/${PROJECT_ENC}/_apis/wit"

# La API de work items acepta como máximo ~200 ids por request; si hay más,
# se pagina en lotes para no romper la respuesta (queda vacía/no-JSON si se
# excede el límite).
BATCH_SIZE=200

fetch_details() {
  local ids_csv="$1"
  local all_ids
  IFS=',' read -ra all_ids <<< "$ids_csv"
  local total=${#all_ids[@]}
  local i=0
  while [ "$i" -lt "$total" ]; do
    local batch=("${all_ids[@]:$i:$BATCH_SIZE}")
    local batch_csv
    batch_csv=$(IFS=,; echo "${batch[*]}")
    curl -s -u ":$AZDO_PAT" \
      "${BASE_URL}/workitems?ids=${batch_csv}&api-version=7.0" \
      | python3 -c "
import json,sys
d=json.load(sys.stdin)
for wi in d['value']:
    f=wi['fields']
    print(f\"[{wi['id']}] {f.get('System.WorkItemType')} - {f.get('System.State')}\")
    print(f\"  Título: {f.get('System.Title')}\")
    print(f\"  Iteration: {f.get('System.IterationPath')}\")
    print(f\"  Area: {f.get('System.AreaPath')}\")
    print(f\"  Cambiado: {f.get('System.ChangedDate')}\")
    print()
"
    i=$((i + BATCH_SIZE))
  done
}

if [ "${1:-}" = "--ids" ]; then
  fetch_details "$2"
  exit 0
fi

WIQL="${1:-SELECT [System.Id], [System.Title], [System.State], [System.WorkItemType], [System.ChangedDate] FROM WorkItems WHERE [System.AssignedTo] = @Me AND [System.State] <> 'Closed' ORDER BY [System.ChangedDate] DESC}"

RESULT=$(curl -s -u ":$AZDO_PAT" \
  -H "Content-Type: application/json" \
  -X POST \
  "${BASE_URL}/wiql?api-version=7.0" \
  -d "{\"query\": \"${WIQL}\"}")

IDS=$(echo "$RESULT" | python3 -c "
import json,sys
d=json.load(sys.stdin)
ids=[str(w['id']) for w in d.get('workItems', [])]
print(','.join(ids))
")

if [ -z "$IDS" ]; then
  echo "Sin resultados."
  exit 0
fi

COUNT=$(echo "$IDS" | tr ',' '\n' | wc -l | tr -d ' ')
if [ "$COUNT" -gt 50 ]; then
  echo "Nota: la query devolvió $COUNT work items. Puede ser lento y difícil de leer; considera acotar el WIQL (por proyecto/iteración/estado/fecha)." >&2
fi

fetch_details "$IDS"
