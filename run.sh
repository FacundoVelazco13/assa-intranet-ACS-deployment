#!/bin/bash
# Script para verificar y crear volúmenes requeridos antes de levantar el stack

set -e

#FILE="assa-compose.yaml"
#VOLUMENES=(alfresco-data postgres-data solr-data solr-home solr-keystores activemq-conf activemq-data activemq-log)
FILE="dev-compose.yaml"
VOLUMENES=(alf-dev-data postgres-dev-data solr-dev-data solr-dev-home solr-dev-keystores activemq-dev-conf activemq-dev-data activemq-dev-log openldap-data openldap-config phpldapadmin)
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