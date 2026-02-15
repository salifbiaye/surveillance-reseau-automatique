#!/bin/bash

# ============================================
# SCRIPT DE CAPTURE PCAP AVEC ROTATION
# ============================================

set -e

# Variables
INTERFACE="${CAPTURE_INTERFACE:-eth0}"
PCAP_DIR="/data/pcap"
MAX_SIZE="${PCAP_MAX_SIZE:-1000}"  # MB
ROTATION_TIME="${PCAP_ROTATION_TIME:-3600}"  # secondes
DATE_FORMAT="%Y-%m-%d"
TIME_FORMAT="%H-%M-%S"

# Créer les répertoires
mkdir -p "$PCAP_DIR/$(date +"$DATE_FORMAT")"

# Fonction de rotation
rotate_pcap() {
    local current_date=$(date +"$DATE_FORMAT")
    local pcap_subdir="$PCAP_DIR/$current_date"
    
    # Créer le répertoire du jour si nécessaire
    mkdir -p "$pcap_subdir"
    
    echo "[$(date)] Rotation: nouveau fichier PCAP dans $pcap_subdir"
}

# Fonction de nettoyage (garder X jours)
cleanup_old_pcap() {
    local retention_days="${PCAP_RETENTION_DAYS:-7}"
    echo "[$(date)] Nettoyage des PCAP > $retention_days jours..."
    find "$PCAP_DIR" -type d -mtime +$retention_days -exec rm -rf {} + 2>/dev/null || true
}

# Trap pour cleanup
trap "echo 'Arrêt de la capture...'; exit 0" SIGTERM SIGINT

echo "============================================"
echo "  DÉMARRAGE CAPTURE PCAP"
echo "============================================"
echo "Interface: $INTERFACE"
echo "Répertoire: $PCAP_DIR"
echo "Taille max: ${MAX_SIZE}MB"
echo "Rotation: ${ROTATION_TIME}s"
echo "============================================"

# Vérifier que l'interface existe
if ! ip link show "$INTERFACE" &>/dev/null; then
    echo "ERREUR: Interface $INTERFACE introuvable!"
    echo "Interfaces disponibles:"
    ip link show
    exit 1
fi

# Nettoyage initial
cleanup_old_pcap

# Capture avec rotation automatique
while true; do
    DATE_DIR=$(date +"$DATE_FORMAT")
    TIMESTAMP=$(date +"$TIME_FORMAT")
    PCAP_FILE="$PCAP_DIR/$DATE_DIR/capture_${TIMESTAMP}.pcap"
    
    echo "[$(date)] Nouvelle capture: $PCAP_FILE"
    
    # Capture avec tcpdump
    timeout $ROTATION_TIME tcpdump \
        -i "$INTERFACE" \
        -w "$PCAP_FILE" \
        -C "$MAX_SIZE" \
        -Z root \
        -n \
        'not port 22 and not port 5601 and not port 9200' \
        2>&1 | while IFS= read -r line; do
            echo "[tcpdump] $line"
        done || true
    
    # Compression du fichier précédent en background
    if [ -f "$PCAP_FILE" ]; then
        (gzip -9 "$PCAP_FILE" 2>/dev/null || true) &
    fi
    
    # Nettoyage périodique
    cleanup_old_pcap
    
    sleep 5
done