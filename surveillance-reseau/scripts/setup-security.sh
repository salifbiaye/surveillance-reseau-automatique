#!/bin/bash
# ============================================
# Configuration de la sécurité Elasticsearch
# ============================================

set -e

echo "[SECURITY] Configuration de la sécurité Elasticsearch..."

# Charger les variables d'environnement
source .env

# Attendre qu'Elasticsearch soit prêt
echo "[SECURITY] Attente d'Elasticsearch..."
until docker exec surveillance-elasticsearch curl -s -u elastic:${ELASTIC_PASSWORD} http://localhost:9200/_cluster/health > /dev/null 2>&1; do
    echo "[SECURITY] Elasticsearch pas encore prêt, attente 5s..."
    sleep 5
done

echo "[SECURITY] Elasticsearch disponible!"

# Créer l'utilisateur kibana_system
echo "[SECURITY] Configuration de l'utilisateur kibana_system..."
docker exec surveillance-elasticsearch curl -X POST -u elastic:${ELASTIC_PASSWORD} \
  "http://localhost:9200/_security/user/kibana_system/_password" \
  -H "Content-Type: application/json" \
  -d "{\"password\":\"${KIBANA_PASSWORD}\"}"

echo ""
echo "[SECURITY] Configuration terminée!"
echo ""
echo "==================================="
echo "INFORMATIONS DE CONNEXION"
echo "==================================="
echo ""
echo "Kibana: http://localhost:5601"
echo "  Username: elastic"
echo "  Password: ${ELASTIC_PASSWORD}"
echo ""
echo "Arkime: http://localhost:8005"
echo "  Username: admin"
echo "  Password: ${ARKIME_PASSWORD}"
echo ""
echo "Elasticsearch API: http://localhost:9200"
echo "  Username: elastic"
echo "  Password: ${ELASTIC_PASSWORD}"
echo ""
echo "==================================="
