#!/bin/bash
# ============================================
# Script d'initialisation et démarrage Arkime
# ============================================

set -e

echo "[ARKIME] Génération de la configuration avec mot de passe..."

# Créer le fichier config.ini avec le mot de passe depuis l'env
cat > /opt/arkime/etc/config.ini << EOF
# ============================================
# ARKIME CONFIGURATION
# Projet Surveillance Réseau - UCAD ESP
# ============================================

[default]
# Elasticsearch configuration
elasticsearch=http://elastic:${ELASTIC_PASSWORD}@elasticsearch:9200
rotateIndex=daily
passwordSecret=SuperSecretPasswordForArkime2024!

# Capture configuration
pcapDir=/data/pcap
pcapReadMethod=tpacketv3
interface=eth0
bpf=

# Viewer configuration
viewPort=8005
viewUrl=http://localhost:8005
certFile=/opt/arkime/etc/arkime.cert
keyFile=/opt/arkime/etc/arkime.key

# User authentication
userNameHeader=
userAuthIps=

# Database
dropUser=false
dropGroup=false

# Logging
logDir=/opt/arkime/logs
logFileBaseName=capture

# Performance
maxFileSizeG=12
maxFileTimeM=60
tcpTimeout=600
tcpSaveTimeout=720
udpTimeout=60
icmpTimeout=10
maxStreams=1000000
maxPackets=10000
minFreeSpaceG=100

# Plugins
plugins=
viewerPlugins=

# GeoIP
geoLite2Country=/opt/arkime/etc/GeoLite2-Country.mmdb
geoLite2ASN=/opt/arkime/etc/GeoLite2-ASN.mmdb

# Packet threads
packetThreads=2

# PCAP writing (disabled, we use external tcpdump)
pcapWriteMethod=null
pcapWriteSize=0

# Tagger
userAutoCreateTmpl={"userId": "%USERNAME%", "userName": "%USERNAME%", "enabled": true, "webEnabled": true, "headerAuthEnabled": false, "emailSearch": true, "createEnabled": false, "removeEnabled": false, "packetSearch": true, "settings": {}}
EOF

echo "[ARKIME] Configuration générée!"

# Attendre qu'Elasticsearch soit prêt
echo "[ARKIME] Attente d'Elasticsearch..."
until curl -s -u elastic:${ELASTIC_PASSWORD} http://elasticsearch:9200/_cluster/health | grep -q '"status":"green"\|"status":"yellow"'; do
    echo "[ARKIME] Elasticsearch pas encore prêt, attente 5s..."
    sleep 5
done

echo "[ARKIME] Elasticsearch disponible!"

# Initialiser la base de données Arkime (première fois uniquement)
if ! curl -s -u elastic:${ELASTIC_PASSWORD} http://elasticsearch:9200/arkime_sessions3-* > /dev/null 2>&1; then
    echo "[ARKIME] Initialisation de la base de données..."
    /opt/arkime/db/db.pl http://elastic:${ELASTIC_PASSWORD}@elasticsearch:9200 init
    
    echo "[ARKIME] Création de l'utilisateur admin..."
    /opt/arkime/bin/arkime_add_user.sh admin "Admin User" ${ARKIME_PASSWORD} --admin
else
    echo "[ARKIME] Base de données déjà initialisée"
fi

echo "[ARKIME] Démarrage du viewer..."
exec /opt/arkime/bin/viewer -c /opt/arkime/etc/config.ini

