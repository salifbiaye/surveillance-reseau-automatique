#!/bin/bash
# Script pour surveiller arp.dat et générer des logs

DATADIR="/var/lib/arpwatch"
LOGFILE="$DATADIR/arpwatch.log"

echo "[ARPWatch Logger] Démarrage de la surveillance de arp.dat..."

# Surveiller arp.dat et logger les changements
while true; do
    if [ -f "$DATADIR/arp.dat" ]; then
        # Lire arp.dat et logger avec timestamp
        while IFS= read -r line; do
            if [ -n "$line" ]; then
                timestamp=$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")
                echo "{\"@timestamp\":\"$timestamp\",\"event_type\":\"arp\",\"message\":\"$line\"}" >> "$LOGFILE"
            fi
        done < "$DATADIR/arp.dat"
    fi

    # Attendre 30 secondes avant de vérifier à nouveau
    sleep 30
done
