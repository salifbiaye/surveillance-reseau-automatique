#!/bin/bash
# Wrapper pour démarrer Arkime avec config personnalisé

# Attendre que le config.ini soit généré par l'image
sleep 3

# Modifier userAuthIps pour autoriser toutes les IPs
if [ -f /opt/arkime/etc/config.ini ]; then
    echo "[ARKIME] Modification de userAuthIps pour autoriser toutes les IPs..."
    sed -i 's/^userAuthIps=.*/userAuthIps=/' /opt/arkime/etc/config.ini
    echo "[ARKIME] Configuration modifiée!"
fi

# Lancer Arkime normalement
exec "$@"

