#!/bin/bash
INTERFACE="${ARPWATCH_INTERFACE:-ens33}"
DATADIR="/var/lib/arpwatch"
LOGFILE="$DATADIR/arpwatch.log"

echo "[ARPWatch] Demarrage..."
echo "[ARPWatch] Interface: $INTERFACE"

echo "[ARPWatch] Installation de tcpdump et iproute2..."
apt-get update -qq 2>&1 > /dev/null
apt-get install -y -qq tcpdump iproute2 2>&1 > /dev/null

mkdir -p "$DATADIR"
touch "$LOGFILE"
chmod 644 "$LOGFILE"

echo "[ARPWatch] Interfaces disponibles:"
ip link show | grep -E "^[0-9]+:" | awk '{print $2}' | sed 's/:$//'

echo "[ARPWatch] Interface configuree: $INTERFACE"

# Test: vérifier si l'interface existe
if ! ip link show "$INTERFACE" > /dev/null 2>&1; then
    echo "[ARPWatch] ERREUR: Interface $INTERFACE n'existe pas!"
    echo "[ARPWatch] Auto-detection de l'interface principale..."

    # Détecter l'interface par défaut
    DEFAULT_IFACE=$(ip route | grep default | awk '{print $5}' | head -1)

    if [ -n "$DEFAULT_IFACE" ]; then
        echo "[ARPWatch] Interface detectee: $DEFAULT_IFACE"
        INTERFACE="$DEFAULT_IFACE"
    else
        echo "[ARPWatch] ERREUR: Impossible de detecter l'interface!"
        exit 1
    fi
fi

echo "[ARPWatch] Interface finale: $INTERFACE"
echo "[ARPWatch] Utilisation de tcpdump pour capturer ARP..."
echo "[ARPWatch] Commande: tcpdump -i any -n -l -e arp"
echo "[ARPWatch] Note: Capture sur TOUTES les interfaces (mode fallback)"

# Capturer les paquets ARP avec tcpdump et parser en temps réel
# -i any = toutes les interfaces (plus fiable)
# -n = no DNS resolution
# -l = line buffered (output immédiat)
# -e = print link-level header (pour voir les MAC addresses)
# arp = filtre ARP uniquement
tcpdump -i any -n -l -e arp 2>&1 | while IFS= read -r line; do
    # Ignorer les messages d'initialisation de tcpdump
    if echo "$line" | grep -qE "listening on|packets captured|packets received"; then
        echo "[ARPWatch] $line"
        continue
    fi

    # Format tcpdump ARP:
    # timestamp MAC1 > MAC2, ARP, length 42: Request who-has IP1 tell IP2
    # timestamp MAC1 > MAC2, ARP, length 42: Reply IP1 is-at MAC1

    # Détecter ARP Request ou Reply
    if echo "$line" | grep -qE "(Request who-has|Reply .* is-at)"; then
        echo "[ARPWatch-DEBUG] $line"

        # Parser ARP Request: "Request who-has IP1 tell IP2"
        if echo "$line" | grep -q "Request who-has"; then
            target_ip=$(echo "$line" | grep -oE "who-has [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | awk '{print $2}')
            sender_ip=$(echo "$line" | grep -oE "tell [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | awk '{print $2}')
            sender_mac=$(echo "$line" | awk '{print $2}')

            if [ -n "$sender_ip" ] && [ -n "$sender_mac" ]; then
                timestamp=$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")
                echo "{\"@timestamp\":\"$timestamp\",\"event_type\":\"arp\",\"ip_address\":\"$sender_ip\",\"mac_address\":\"$sender_mac\",\"action\":\"arp_request\",\"target_ip\":\"$target_ip\",\"interface\":\"$INTERFACE\"}" >> "$LOGFILE"
                echo "[ARPWatch] ARP Request: $sender_ip ($sender_mac) asking for $target_ip"
            fi
        fi

        # Parser ARP Reply: "Reply IP is-at MAC"
        if echo "$line" | grep -q "Reply .* is-at"; then
            reply_ip=$(echo "$line" | grep -oE "Reply [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | awk '{print $2}')
            reply_mac=$(echo "$line" | grep -oE "is-at [0-9a-fA-F:]{17}" | awk '{print $2}')

            if [ -n "$reply_ip" ] && [ -n "$reply_mac" ]; then
                timestamp=$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")
                echo "{\"@timestamp\":\"$timestamp\",\"event_type\":\"arp\",\"ip_address\":\"$reply_ip\",\"mac_address\":\"$reply_mac\",\"action\":\"arp_reply\",\"interface\":\"$INTERFACE\"}" >> "$LOGFILE"
                echo "[ARPWatch] ARP Reply: $reply_ip is-at $reply_mac"
            fi
        fi
    fi
done
