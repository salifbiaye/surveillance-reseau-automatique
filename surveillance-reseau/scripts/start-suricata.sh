#!/bin/bash
# Script pour lancer Suricata sans suricata-update

echo "=========================================="
echo "  DÉMARRAGE SURICATA IDS"
echo "=========================================="
echo "Interface: ${CAPTURE_INTERFACE:-ens33}"
echo "Config: /etc/suricata/suricata.yaml"
echo "=========================================="

# Lance Suricata directement en mode IDS
exec /usr/bin/suricata \
  -c /etc/suricata/suricata.yaml \
  -i ${CAPTURE_INTERFACE:-ens33} \
  -v
