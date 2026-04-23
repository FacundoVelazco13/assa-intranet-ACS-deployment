#!/bin/bash
# Script para verificar y crear volúmenes requeridos antes de levantar el stack

set -e

TARGET_ENV="${2:-dev}"

case "$TARGET_ENV" in
  dev)
    FILE="dev-compose.yaml"
    VOLUMENES=(alf-dev-data postgres-dev-data solr-dev-data solr-dev-home solr-dev-keystores activemq-dev-conf activemq-dev-data activemq-dev-log openldap-data openldap-config phpldapadmin minio-dev-volume)
    ;;
  prod|assa)
    FILE="assa-compose.yaml"
    VOLUMENES=(alfresco-data postgres-data solr-data solr-home solr-keystores activemq-conf activemq-data activemq-log)
    ;;
  *)
    echo "Uso: $0 {up|down} [dev|prod]"
    exit 1
    ;;
esac

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
    echo ""
    echo "============================================"
    echo "URLs de acceso:"
    echo "============================================"
    case "$TARGET_ENV" in
      dev)
        echo "  - Alfresco:     http://localhost:8080/alfresco"
        echo "  - Share:        http://localhost:8080/share"
        echo "  - Content App:  http://localhost:8080/"
        echo "  - OOP Health:   http://localhost:9081/actuator/health"
        echo "  - OOP iTop API: http://localhost:8080/alfresco-oop/api/itop/data"
        echo "  - phpLDAPadmin: http://localhost:8081"
        echo "  - Solr:         http://localhost:8083"
        ;;
      prod|assa)
        echo "  - Alfresco:     http://localhost:8080/alfresco"
        echo "  - Share:        http://localhost:8080/share"
        echo "  - Content App:  http://localhost:8080/"
        echo "  - OOP Health:   http://localhost:9081/actuator/health (solo localhost)"
        echo "  - OOP iTop API: http://localhost:8080/alfresco-oop/api/itop/data"
        ;;
    esac
    echo "============================================"
    ;;
  down)
    echo "[INFO] Bajando el stack con $FILE..."
    docker compose -f "$FILE" down
    ;;
  status)
    echo "[INFO] Estado de los servicios..."
    docker compose -f "$FILE" ps
    echo ""
    echo "============================================"
    echo "Health checks:"
    echo "============================================"
    echo "  - Alfresco:      curl -s http://localhost:8080/alfresco/api/-default-/public/alfresco/versions/1/probes/-ready-"
    echo "  - OOP Extension: curl -s http://localhost:9081/actuator/health"
    echo "  - iTop API:      curl -s http://localhost:8080/alfresco-oop/api/itop/cache/status"
    echo "============================================"
    ;;
  *)
    echo "Uso: $0 {up|down|status} [dev|prod]"
    exit 1
    ;;
esac