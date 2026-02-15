#!/bin/bash

# Script de rotation des fichiers PCAP
# Supprime les fichiers plus anciens que PCAP_RETENTION_DAYS

PCAP_DIR="/data/pcap"
RETENTION_DAYS=${PCAP_RETENTION_DAYS:-7}

echo "Rotation des fichiers PCAP..."
echo "Répertoire: ${PCAP_DIR}"
echo "Rétention: ${RETENTION_DAYS} jours"

# Trouver et supprimer les fichiers plus anciens que RETENTION_DAYS
find ${PCAP_DIR} -name "*.pcap*" -type f -mtime +${RETENTION_DAYS} -delete

echo "Rotation terminée"

# Afficher l'espace disque utilisé
du -sh ${PCAP_DIR}
