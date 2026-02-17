#!/bin/bash
# Script pour lancer Suricata avec mise à jour automatique des règles

echo "=========================================="
echo "  DÉMARRAGE SURICATA IDS"
echo "=========================================="
echo "Interface: ${CAPTURE_INTERFACE:-ens33}"
echo "Config: /etc/suricata/suricata.yaml"
echo "=========================================="

# Vérifier si les règles ont déjà été téléchargées
RULES_FILE="/var/lib/suricata/rules/suricata.rules"

if [ ! -f "$RULES_FILE" ] || [ ! -s "$RULES_FILE" ]; then
    echo "[SURICATA] Première exécution - Téléchargement des règles..."
    suricata-update
    echo "[SURICATA] Règles téléchargées avec succès!"
else
    echo "[SURICATA] Règles déjà présentes, pas de mise à jour nécessaire"
    echo "[SURICATA] Pour forcer la mise à jour: docker exec -it surveillance-suricata suricata-update"
fi

echo "[SURICATA] Démarrage de Suricata..."

# Lance Suricata directement en mode IDS
exec /usr/bin/suricata \
  -c /etc/suricata/suricata.yaml \
  -i ${CAPTURE_INTERFACE:-ens33} \
  -v
