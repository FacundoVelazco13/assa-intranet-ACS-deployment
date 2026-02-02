#!/bin/bash
# Script para verificar y crear volúmenes requeridos antes de levantar el stack

set -e

#FILE="assa-compose.yaml"
#VOLUMENES=(alfresco-data postgres-data solr-data)
FILE="dev-compose.yaml"
VOLUMENES=(alf-dev-data postgres-dev-data solr-dev-data)

case "$1" in
  up)
    for VOLUMEN in "${VOLUMENES[@]}"; do
      if ! docker volume inspect "$VOLUMEN" >/dev/null 2>&1; then
        echo "[INFO] El volumen '$VOLUMEN' no existe. Creando..."
        docker volume create "$VOLUMEN"
      else
        echo "[OK] El volumen '$VOLUMEN' ya existe."
      fi
    done
    echo "[INFO] Levantando el stack con $FILE..."
    docker compose -f "$FILE" up --build -d
    ;;
  down)
    echo "[INFO] Bajando el stack con $FILE..."
    docker compose -f "$FILE" down
    ;;
  *)
    echo "Uso: $0 {up|down}"
    exit 1
    ;;
esac