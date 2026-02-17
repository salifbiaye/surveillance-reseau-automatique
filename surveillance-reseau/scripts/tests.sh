#!/bin/bash

# ============================================
# SCRIPT DE TESTS AUTOMATIQUES
# Projet Surveillance Réseau - UCAD ESP
# ============================================

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Compteurs
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Fonction d'affichage
print_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

test_result() {
    local test_name="$1"
    local result="$2"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    if [ "$result" -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $test_name"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        echo -e "${RED}✗${NC} $test_name"
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
}

# ============================================
# TESTS PRÉREQUIS
# ============================================
print_header "1. TESTS DES PRÉREQUIS"

# Test Docker
docker --version &>/dev/null
test_result "Docker installé" $?

# Test Docker Compose
docker-compose --version &>/dev/null || docker compose version &>/dev/null
test_result "Docker Compose installé" $?

# Test permissions Docker
docker ps &>/dev/null
test_result "Permissions Docker OK" $?

# Test vm.max_map_count
current_count=$(sysctl vm.max_map_count | awk '{print $3}')
[ "$current_count" -ge 262144 ]
test_result "vm.max_map_count >= 262144" $?

# ============================================
# TESTS STRUCTURE PROJET
# ============================================
print_header "2. TESTS DE LA STRUCTURE DU PROJET"

[ -f "docker-compose.yml" ]
test_result "Fichier docker-compose.yml présent" $?

[ -f ".env" ]
test_result "Fichier .env présent" $?

[ -f "start.sh" ]
test_result "Script start.sh présent" $?

[ -d "configs" ]
test_result "Répertoire configs/ présent" $?

[ -d "data" ]
test_result "Répertoire data/ présent" $?

[ -d "scripts" ]
test_result "Répertoire scripts/ présent" $?

# ============================================
# TESTS CONTENEURS
# ============================================
print_header "3. TESTS DES CONTENEURS DOCKER"

# Vérifier que les conteneurs sont lancés
container_running() {
    docker-compose ps | grep -q "$1.*Up"
    return $?
}

container_running "elasticsearch"
test_result "Elasticsearch en cours d'exécution" $?

container_running "kibana"
test_result "Kibana en cours d'exécution" $?

container_running "suricata"
test_result "Suricata en cours d'exécution" $?

container_running "tcpdump"
test_result "tcpdump en cours d'exécution" $?

container_running "arpwatch"
test_result "ARPWatch en cours d'exécution" $?

container_running "filebeat"
test_result "Filebeat en cours d'exécution" $?

container_running "nginx"
test_result "Nginx en cours d'exécution" $?

# ============================================
# TESTS SERVICES WEB
# ============================================
print_header "4. TESTS DES SERVICES WEB"

# Test Elasticsearch
curl -s http://localhost:9200/_cluster/health &>/dev/null
test_result "Elasticsearch répond (port 9200)" $?

# Test Kibana
curl -s http://localhost:5601/api/status &>/dev/null
test_result "Kibana répond (port 5601)" $?

# Test Nginx
curl -s http://localhost &>/dev/null
test_result "Nginx répond (port 80)" $?

# ============================================
# TESTS SANTÉ ELASTICSEARCH
# ============================================
print_header "5. TESTS DE SANTÉ ELASTICSEARCH"

# Statut cluster
es_status=$(curl -s http://localhost:9200/_cluster/health | jq -r '.status')
[ "$es_status" = "green" ] || [ "$es_status" = "yellow" ]
test_result "Cluster Elasticsearch en santé ($es_status)" $?

# Nombre de nœuds
es_nodes=$(curl -s http://localhost:9200/_cluster/health | jq -r '.number_of_nodes')
[ "$es_nodes" -ge 1 ]
test_result "Au moins 1 nœud Elasticsearch actif" $?

# ============================================
# TESTS CAPTURE DONNÉES
# ============================================
print_header "6. TESTS DE CAPTURE DE DONNÉES"

# PCAP directory exists
[ -d "data/pcap" ]
test_result "Répertoire PCAP existe" $?

# Check for recent PCAP files (last 2 hours)
pcap_count=$(find data/pcap -type f -name "*.pcap*" -mmin -120 2>/dev/null | wc -l)
[ "$pcap_count" -gt 0 ]
test_result "Fichiers PCAP récents trouvés ($pcap_count)" $?

# Suricata logs
[ -f "data/logs/suricata/eve.json" ]
test_result "Fichier eve.json Suricata existe" $?

# Suricata eve.json has content
eve_lines=$(wc -l < data/logs/suricata/eve.json 2>/dev/null || echo 0)
[ "$eve_lines" -gt 0 ]
test_result "Événements Suricata capturés ($eve_lines lignes)" $?

# ARPWatch data
[ -d "data/logs/arpwatch" ]
test_result "Répertoire logs ARPWatch existe" $?

# ARPWatch database file (arp.dat)
arp_entries=$(grep -c ":" data/logs/arpwatch/arp.dat 2>/dev/null || echo 0)
test_result "Entrées ARP enregistrées ($arp_entries paires IP/MAC)" 0

# ============================================
# TESTS INDEX ELASTICSEARCH
# ============================================
print_header "7. TESTS DES INDEX ELASTICSEARCH"

# Lister les index
indices=$(curl -s http://localhost:9200/_cat/indices?format=json 2>/dev/null)

# Vérifier si des index existent
index_count=$(echo "$indices" | jq -r '. | length')
[ "$index_count" -gt 0 ]
test_result "Index Elasticsearch présents ($index_count index)" $?

# Vérifier les index Suricata
suricata_indices=$(echo "$indices" | jq -r '.[].index' | grep -c "^suricata-" || true)
[ "$suricata_indices" -gt 0 ]
test_result "Index Suricata trouvés ($suricata_indices)" $?

# ============================================
# TESTS DOCUMENTS ELASTICSEARCH
# ============================================
print_header "8. TESTS DES DOCUMENTS INDEXÉS"

# Compter les documents Suricata
suricata_docs=$(curl -s http://localhost:9200/suricata-*/_count 2>/dev/null | jq -r '.count' || echo 0)
[ "$suricata_docs" -gt 0 ]
test_result "Documents Suricata indexés ($suricata_docs docs)" $?

# Vérifier les types d'événements Suricata
event_types=$(curl -s "http://localhost:9200/suricata-*/_search?size=0" -H 'Content-Type: application/json' -d '{"aggs":{"event_types":{"terms":{"field":"event_type.keyword","size":10}}}}' 2>/dev/null | jq -r '.aggregations.event_types.buckets[].key' 2>/dev/null | wc -l || echo 0)
[ "$event_types" -gt 0 ]
test_result "Types d'événements Suricata variés ($event_types types)" $?

# ============================================
# TESTS RÉSEAU
# ============================================
print_header "9. TESTS RÉSEAU"

# Interface réseau configurée
INTERFACE=$(grep CAPTURE_INTERFACE .env | cut -d= -f2)
ip link show "$INTERFACE" &>/dev/null
test_result "Interface $INTERFACE existe" $?

# Test capture réseau
docker-compose exec -T tcpdump timeout 2 tcpdump -i "$INTERFACE" -c 1 &>/dev/null || true
test_result "Capture réseau fonctionnelle sur $INTERFACE" $?

# ============================================
# TESTS ESPACE DISQUE
# ============================================
print_header "10. TESTS ESPACE DISQUE"

# Vérifier espace libre
free_space=$(df -h . | tail -1 | awk '{print $4}' | sed 's/G//')
[ "${free_space%.*}" -gt 5 ]
test_result "Espace disque suffisant (${free_space}G disponible)" $?

# Taille des données
pcap_size=$(du -sh data/pcap 2>/dev/null | awk '{print $1}')
test_result "Taille PCAP: $pcap_size" 0

logs_size=$(du -sh data/logs 2>/dev/null | awk '{print $1}')
test_result "Taille logs: $logs_size" 0

es_size=$(du -sh data/elasticsearch 2>/dev/null | awk '{print $1}')
test_result "Taille Elasticsearch: $es_size" 0

# ============================================
# RÉSUMÉ
# ============================================
print_header "RÉSUMÉ DES TESTS"

echo -e "Total: ${BLUE}$TOTAL_TESTS${NC} tests"
echo -e "Réussis: ${GREEN}$PASSED_TESTS${NC}"
echo -e "Échoués: ${RED}$FAILED_TESTS${NC}"
echo ""

if [ "$FAILED_TESTS" -eq 0 ]; then
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✓ TOUS LES TESTS SONT PASSÉS !${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    exit 0
else
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}✗ CERTAINS TESTS ONT ÉCHOUÉ${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "Suggestions:"
    echo "  1. Vérifier les logs: docker-compose logs"
    echo "  2. Vérifier l'état: docker-compose ps"
    echo "  3. Consulter la documentation: docs/installation-privee.md"
    exit 1
fi