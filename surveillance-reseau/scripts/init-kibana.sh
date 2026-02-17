#!/bin/bash

################################################################################
# Script d'initialisation automatique de Kibana
# Exécuté automatiquement au démarrage via container d'init
################################################################################

set -e

echo "[INIT] Attente de Kibana..."

# Attendre que Kibana soit prêt (max 5 minutes)
for i in {1..100}; do
    if curl -s http://kibana:5601/api/status > /dev/null 2>&1; then
        echo "[INIT] Kibana est prêt!"
        break
    fi
    sleep 3
done

# Attendre 10 secondes supplémentaires pour stabilisation
sleep 10

echo "[INIT] Configuration des Data Views..."

# Supprimer les anciens Data Views s'ils existent (ignorer les erreurs)
echo "[INIT] Nettoyage des anciens Data Views..."
curl -X DELETE "http://kibana:5601/api/data_views/data_view/suricata-*" \
  -H "kbn-xsrf: true" > /dev/null 2>&1 || true
curl -X DELETE "http://kibana:5601/api/data_views/data_view/arpwatch-*" \
  -H "kbn-xsrf: true" > /dev/null 2>&1 || true

# Créer Data View Suricata avec ID explicite
echo "[INIT] Création du Data View Suricata..."
SURICATA_RESPONSE=$(curl -X POST "http://kibana:5601/api/data_views/data_view" \
  -H "kbn-xsrf: true" \
  -H "Content-Type: application/json" \
  -d '{
    "data_view": {
      "id": "suricata-events",
      "title": "suricata-*",
      "name": "Suricata Events",
      "timeFieldName": "timestamp"
    }
  }' 2>&1)
echo "[INIT] Suricata Data View créé"

# Créer Data View ARPWatch avec ID explicite
echo "[INIT] Création du Data View ARPWatch..."
ARPWATCH_RESPONSE=$(curl -X POST "http://kibana:5601/api/data_views/data_view" \
  -H "kbn-xsrf: true" \
  -H "Content-Type: application/json" \
  -d '{
    "data_view": {
      "id": "arpwatch-events",
      "title": "arpwatch-*",
      "name": "ARPWatch Events",
      "timeFieldName": "@timestamp"
    }
  }' 2>&1)
echo "[INIT] ARPWatch Data View créé"

# Créer Data View pfSense avec ID explicite (OPTIONNEL - ne bloque pas si pas de logs)
echo "[INIT] Création du Data View pfSense (optionnel)..."
curl -X POST "http://kibana:5601/api/data_views/data_view" \
  -H "kbn-xsrf: true" \
  -H "Content-Type: application/json" \
  -d '{
    "data_view": {
      "id": "pfsense-firewall",
      "title": "pfsense-*",
      "name": "pfSense Firewall Logs",
      "timeFieldName": "@timestamp"
    }
  }' > /dev/null 2>&1 || echo "[INIT] pfSense Data View création échouée (normal si pas de logs pfSense)"

# Définir Suricata comme Data View par défaut
echo "[INIT] Configuration du Data View par défaut..."
curl -X POST "http://kibana:5601/api/data_views/default" \
  -H "kbn-xsrf: true" \
  -H "Content-Type: application/json" \
  -d '{"data_view_id": "suricata-events"}' 2>&1 | head -5

# Attendre un peu pour que les Data Views soient bien indexés
sleep 3

echo "[INIT] Nettoyage des anciennes visualisations..."

# Supprimer toutes les anciennes visualisations (ignorer les erreurs si elles n'existent pas)
curl -X DELETE "http://kibana:5601/api/saved_objects/visualization/total-evenements" -H "kbn-xsrf: true" > /dev/null 2>&1 || true
curl -X DELETE "http://kibana:5601/api/saved_objects/visualization/repartition-type" -H "kbn-xsrf: true" > /dev/null 2>&1 || true
curl -X DELETE "http://kibana:5601/api/saved_objects/visualization/timeline-reseau" -H "kbn-xsrf: true" > /dev/null 2>&1 || true
curl -X DELETE "http://kibana:5601/api/saved_objects/visualization/top-sites-recents" -H "kbn-xsrf: true" > /dev/null 2>&1 || true
curl -X DELETE "http://kibana:5601/api/saved_objects/visualization/dns-par-temps" -H "kbn-xsrf: true" > /dev/null 2>&1 || true
curl -X DELETE "http://kibana:5601/api/saved_objects/visualization/total-arp" -H "kbn-xsrf: true" > /dev/null 2>&1 || true
curl -X DELETE "http://kibana:5601/api/saved_objects/visualization/arp-request-reply" -H "kbn-xsrf: true" > /dev/null 2>&1 || true
curl -X DELETE "http://kibana:5601/api/saved_objects/visualization/mapping-ip-mac" -H "kbn-xsrf: true" > /dev/null 2>&1 || true
curl -X DELETE "http://kibana:5601/api/saved_objects/visualization/top-ip-arp" -H "kbn-xsrf: true" > /dev/null 2>&1 || true
curl -X DELETE "http://kibana:5601/api/saved_objects/visualization/timeline-arp" -H "kbn-xsrf: true" > /dev/null 2>&1 || true

echo "[INIT] Création des visualisations Suricata..."

# Créer une visualisation simple: Compteur d'événements
curl -X POST "http://kibana:5601/api/saved_objects/visualization/total-evenements" \
  -H "kbn-xsrf: true" \
  -H "Content-Type: application/json" \
  -d '{
    "attributes": {
      "title": "Total Événements",
      "visState": "{\"title\":\"Total Événements\",\"type\":\"metric\",\"aggs\":[{\"id\":\"1\",\"enabled\":true,\"type\":\"count\",\"schema\":\"metric\",\"params\":{}}],\"params\":{\"addTooltip\":true,\"addLegend\":false,\"type\":\"metric\",\"metric\":{\"percentageMode\":false,\"useRanges\":false,\"colorSchema\":\"Green to Red\",\"metricColorMode\":\"None\",\"colorsRange\":[{\"from\":0,\"to\":10000}],\"labels\":{\"show\":true},\"invertColors\":false,\"style\":{\"bgFill\":\"#000\",\"bgColor\":false,\"labelColor\":false,\"subText\":\"\",\"fontSize\":60}}}}",
      "uiStateJSON": "{}",
      "description": "Nombre total d'\''événements capturés",
      "version": 1,
      "kibanaSavedObjectMeta": {
        "searchSourceJSON": "{\"index\":\"suricata-events\",\"query\":{\"query\":\"\",\"language\":\"kuery\"},\"filter\":[]}"
      }
    }
  }' > /dev/null 2>&1

# Créer visualisation: Événements par type (Pie chart)
curl -X POST "http://kibana:5601/api/saved_objects/visualization/repartition-type" \
  -H "kbn-xsrf: true" \
  -H "Content-Type: application/json" \
  -d '{
    "attributes": {
      "title": "Répartition par Type",
      "visState": "{\"title\":\"Répartition par Type\",\"type\":\"pie\",\"aggs\":[{\"id\":\"1\",\"enabled\":true,\"type\":\"count\",\"schema\":\"metric\",\"params\":{}},{\"id\":\"2\",\"enabled\":true,\"type\":\"terms\",\"schema\":\"segment\",\"params\":{\"field\":\"event_type.keyword\",\"size\":10,\"order\":\"desc\",\"orderBy\":\"1\"}}],\"params\":{\"type\":\"pie\",\"addTooltip\":true,\"addLegend\":true,\"legendPosition\":\"right\",\"isDonut\":true,\"labels\":{\"show\":true,\"values\":true,\"last_level\":true,\"truncate\":100}}}",
      "uiStateJSON": "{}",
      "description": "Distribution des événements par type",
      "version": 1,
      "kibanaSavedObjectMeta": {
        "searchSourceJSON": "{\"index\":\"suricata-events\",\"query\":{\"query\":\"\",\"language\":\"kuery\"},\"filter\":[]}"
      }
    }
  }' > /dev/null 2>&1

# Créer visualisation: Timeline Réseau (Area chart simple)
curl -X POST "http://kibana:5601/api/saved_objects/visualization/timeline-reseau" \
  -H "kbn-xsrf: true" \
  -H "Content-Type: application/json" \
  -d '{
    "attributes": {
      "title": "Timeline Réseau",
      "visState": "{\"title\":\"Timeline Réseau\",\"type\":\"area\",\"aggs\":[{\"id\":\"1\",\"enabled\":true,\"type\":\"count\",\"schema\":\"metric\",\"params\":{}},{\"id\":\"2\",\"enabled\":true,\"type\":\"date_histogram\",\"schema\":\"segment\",\"params\":{\"field\":\"timestamp\",\"interval\":\"auto\",\"min_doc_count\":1}}],\"params\":{\"type\":\"area\",\"addLegend\":true,\"addTooltip\":true,\"legendPosition\":\"right\",\"times\":[]}}",
      "uiStateJSON": "{}",
      "description": "Évolution du trafic réseau dans le temps",
      "version": 1,
      "kibanaSavedObjectMeta": {
        "searchSourceJSON": "{\"index\":\"suricata-events\",\"query\":{\"query\":\"\",\"language\":\"kuery\"},\"filter\":[]}"
      }
    }
  }' > /dev/null 2>&1

# Créer visualisation: Top 20 Sites Récemment Visités (avec IP source)
curl -X POST "http://kibana:5601/api/saved_objects/visualization/top-sites-recents" \
  -H "kbn-xsrf: true" \
  -H "Content-Type: application/json" \
  -d '{
    "attributes": {
      "title": "Top 20 Sites Récemment Visités",
      "visState": "{\"title\":\"Top 20 Sites Récemment Visités\",\"type\":\"table\",\"aggs\":[{\"id\":\"1\",\"enabled\":true,\"type\":\"max\",\"schema\":\"metric\",\"params\":{\"field\":\"timestamp\",\"customLabel\":\"Dernière visite\"}},{\"id\":\"2\",\"enabled\":true,\"type\":\"terms\",\"schema\":\"bucket\",\"params\":{\"field\":\"dns.rrname.keyword\",\"size\":20,\"order\":\"desc\",\"orderBy\":\"1\",\"customLabel\":\"Domaine\"}},{\"id\":\"3\",\"enabled\":true,\"type\":\"terms\",\"schema\":\"bucket\",\"params\":{\"field\":\"src_ip.keyword\",\"size\":5,\"order\":\"desc\",\"orderBy\":\"1\",\"customLabel\":\"IP Source\"}}],\"params\":{\"perPage\":20,\"showPartialRows\":false,\"showMetricsAtAllLevels\":false,\"showTotal\":false,\"totalFunc\":\"sum\",\"percentageCol\":false}}",
      "uiStateJSON": "{}",
      "description": "Les 20 sites les plus récemment visités avec IP source (qui a visité)",
      "version": 1,
      "kibanaSavedObjectMeta": {
        "searchSourceJSON": "{\"index\":\"suricata-events\",\"query\":{\"query\":\"event_type: \\\"dns\\\"\",\"language\":\"kuery\"},\"filter\":[]}"
      }
    }
  }' > /dev/null 2>&1

# Créer visualisation: Requêtes DNS par Temps (avec IP source)
curl -X POST "http://kibana:5601/api/saved_objects/visualization/dns-par-temps" \
  -H "kbn-xsrf: true" \
  -H "Content-Type: application/json" \
  -d '{
    "attributes": {
      "title": "Requêtes DNS par Temps",
      "visState": "{\"title\":\"Requêtes DNS par Temps\",\"type\":\"table\",\"aggs\":[{\"id\":\"1\",\"enabled\":true,\"type\":\"count\",\"schema\":\"metric\",\"params\":{\"customLabel\":\"Nb Requêtes\"}},{\"id\":\"2\",\"enabled\":true,\"type\":\"terms\",\"schema\":\"bucket\",\"params\":{\"field\":\"dns.rrname.keyword\",\"size\":30,\"order\":\"desc\",\"orderBy\":\"1\",\"customLabel\":\"Domaine\"}},{\"id\":\"3\",\"enabled\":true,\"type\":\"terms\",\"schema\":\"bucket\",\"params\":{\"field\":\"src_ip.keyword\",\"size\":5,\"order\":\"desc\",\"orderBy\":\"1\",\"customLabel\":\"IP Source\"}},{\"id\":\"4\",\"enabled\":true,\"type\":\"max\",\"schema\":\"metric\",\"params\":{\"field\":\"timestamp\",\"customLabel\":\"Dernière requête\"}}],\"params\":{\"perPage\":20,\"showPartialRows\":false,\"showMetricsAtAllLevels\":false,\"showTotal\":false,\"totalFunc\":\"sum\",\"percentageCol\":false}}",
      "uiStateJSON": "{}",
      "description": "Requêtes DNS avec domaine et heure de dernière requête",
      "version": 1,
      "kibanaSavedObjectMeta": {
        "searchSourceJSON": "{\"index\":\"suricata-events\",\"query\":{\"query\":\"event_type: \\\"dns\\\"\",\"language\":\"kuery\"},\"filter\":[]}"
      }
    }
  }' > /dev/null 2>&1

# ============================================
# VISUALISATIONS ARPWATCH
# ============================================

echo "[INIT] Création des visualisations ARPWatch..."

# Visualisation: Total Événements ARP
curl -X POST "http://kibana:5601/api/saved_objects/visualization/total-arp" \
  -H "kbn-xsrf: true" \
  -H "Content-Type: application/json" \
  -d '{
    "attributes": {
      "title": "Total Événements ARP",
      "visState": "{\"title\":\"Total Événements ARP\",\"type\":\"metric\",\"aggs\":[{\"id\":\"1\",\"enabled\":true,\"type\":\"count\",\"schema\":\"metric\",\"params\":{}}],\"params\":{\"addTooltip\":true,\"addLegend\":false,\"type\":\"metric\",\"metric\":{\"percentageMode\":false,\"useRanges\":false,\"colorSchema\":\"Green to Red\",\"metricColorMode\":\"None\",\"colorsRange\":[{\"from\":0,\"to\":10000}],\"labels\":{\"show\":true},\"invertColors\":false,\"style\":{\"bgFill\":\"#000\",\"bgColor\":false,\"labelColor\":false,\"subText\":\"\",\"fontSize\":60}}}}",
      "uiStateJSON": "{}",
      "description": "Nombre total d'\''événements ARP capturés",
      "version": 1,
      "kibanaSavedObjectMeta": {
        "searchSourceJSON": "{\"index\":\"arpwatch-events\",\"query\":{\"query\":\"\",\"language\":\"kuery\"},\"filter\":[]}"
      }
    }
  }' > /dev/null 2>&1

# Visualisation: ARP Request vs Reply
curl -X POST "http://kibana:5601/api/saved_objects/visualization/arp-request-reply" \
  -H "kbn-xsrf: true" \
  -H "Content-Type: application/json" \
  -d '{
    "attributes": {
      "title": "ARP Request vs Reply",
      "visState": "{\"title\":\"ARP Request vs Reply\",\"type\":\"pie\",\"aggs\":[{\"id\":\"1\",\"enabled\":true,\"type\":\"count\",\"schema\":\"metric\",\"params\":{}},{\"id\":\"2\",\"enabled\":true,\"type\":\"terms\",\"schema\":\"segment\",\"params\":{\"field\":\"action.keyword\",\"size\":5,\"order\":\"desc\",\"orderBy\":\"1\",\"customLabel\":\"Type\"}}],\"params\":{\"type\":\"pie\",\"addTooltip\":true,\"addLegend\":true,\"legendPosition\":\"right\",\"isDonut\":true,\"labels\":{\"show\":true,\"values\":true,\"last_level\":true,\"truncate\":100}}}",
      "uiStateJSON": "{}",
      "description": "Répartition des requêtes ARP (Request vs Reply)",
      "version": 1,
      "kibanaSavedObjectMeta": {
        "searchSourceJSON": "{\"index\":\"arpwatch-events\",\"query\":{\"query\":\"\",\"language\":\"kuery\"},\"filter\":[]}"
      }
    }
  }' > /dev/null 2>&1

# Visualisation: Mapping IP-MAC (Table)
curl -X POST "http://kibana:5601/api/saved_objects/visualization/mapping-ip-mac" \
  -H "kbn-xsrf: true" \
  -H "Content-Type: application/json" \
  -d '{
    "attributes": {
      "title": "Mapping IP-MAC",
      "visState": "{\"title\":\"Mapping IP-MAC\",\"type\":\"table\",\"aggs\":[{\"id\":\"1\",\"enabled\":true,\"type\":\"count\",\"schema\":\"metric\",\"params\":{\"customLabel\":\"Nb Paquets\"}},{\"id\":\"2\",\"enabled\":true,\"type\":\"terms\",\"schema\":\"bucket\",\"params\":{\"field\":\"ip_address.keyword\",\"size\":50,\"order\":\"desc\",\"orderBy\":\"1\",\"customLabel\":\"Adresse IP\"}},{\"id\":\"3\",\"enabled\":true,\"type\":\"terms\",\"schema\":\"bucket\",\"params\":{\"field\":\"mac_address.keyword\",\"size\":5,\"order\":\"desc\",\"orderBy\":\"1\",\"customLabel\":\"Adresse MAC\"}}],\"params\":{\"perPage\":20,\"showPartialRows\":false,\"showMetricsAtAllLevels\":false,\"showTotal\":false,\"totalFunc\":\"sum\",\"percentageCol\":false}}",
      "uiStateJSON": "{}",
      "description": "Table de mapping entre adresses IP et MAC",
      "version": 1,
      "kibanaSavedObjectMeta": {
        "searchSourceJSON": "{\"index\":\"arpwatch-events\",\"query\":{\"query\":\"\",\"language\":\"kuery\"},\"filter\":[]}"
      }
    }
  }' > /dev/null 2>&1

# Visualisation: Top 20 IP ARP (Version simple - Table)
curl -X POST "http://kibana:5601/api/saved_objects/visualization/top-ip-arp" \
  -H "kbn-xsrf: true" \
  -H "Content-Type: application/json" \
  -d '{
    "attributes": {
      "title": "Top 20 IP ARP",
      "visState": "{\"title\":\"Top 20 IP ARP\",\"type\":\"table\",\"aggs\":[{\"id\":\"1\",\"enabled\":true,\"type\":\"count\",\"schema\":\"metric\",\"params\":{\"customLabel\":\"Paquets ARP\"}},{\"id\":\"2\",\"enabled\":true,\"type\":\"terms\",\"schema\":\"bucket\",\"params\":{\"field\":\"ip_address.keyword\",\"size\":20,\"order\":\"desc\",\"orderBy\":\"1\",\"customLabel\":\"Adresse IP\"}}],\"params\":{\"perPage\":20,\"showPartialRows\":false,\"showMetricsAtAllLevels\":false,\"showTotal\":false,\"totalFunc\":\"sum\",\"percentageCol\":false}}",
      "uiStateJSON": "{}",
      "description": "Les 20 adresses IP avec le plus d'\''activité ARP",
      "version": 1,
      "kibanaSavedObjectMeta": {
        "searchSourceJSON": "{\"index\":\"arpwatch-events\",\"query\":{\"query\":\"\",\"language\":\"kuery\"},\"filter\":[]}"
      }
    }
  }' > /dev/null 2>&1

# Visualisation: Timeline ARP (Area chart simple)
curl -X POST "http://kibana:5601/api/saved_objects/visualization/timeline-arp" \
  -H "kbn-xsrf: true" \
  -H "Content-Type: application/json" \
  -d '{
    "attributes": {
      "title": "Timeline ARP",
      "visState": "{\"title\":\"Timeline ARP\",\"type\":\"area\",\"aggs\":[{\"id\":\"1\",\"enabled\":true,\"type\":\"count\",\"schema\":\"metric\",\"params\":{}},{\"id\":\"2\",\"enabled\":true,\"type\":\"date_histogram\",\"schema\":\"segment\",\"params\":{\"field\":\"@timestamp\",\"interval\":\"auto\",\"min_doc_count\":1}}],\"params\":{\"type\":\"area\",\"addLegend\":true,\"addTooltip\":true,\"legendPosition\":\"right\",\"times\":[]}}",
      "uiStateJSON": "{}",
      "description": "Évolution du trafic ARP dans le temps",
      "version": 1,
      "kibanaSavedObjectMeta": {
        "searchSourceJSON": "{\"index\":\"arpwatch-events\",\"query\":{\"query\":\"\",\"language\":\"kuery\"},\"filter\":[]}"
      }
    }
  }' > /dev/null 2>&1

echo "[INIT] Dashboards et visualisations créés!"
echo "[INIT] Configuration Kibana terminée!"
echo "[INIT] "
echo "[INIT] ✅ Data Views créés:"
echo "[INIT]    • Suricata Events (suricata-*)"
echo "[INIT]    • ARPWatch Events (arpwatch-*)"
echo "[INIT]    • pfSense Firewall Logs (pfsense-*) [optionnel]"
echo "[INIT] "
echo "[INIT] ✅ Visualisations Suricata créées:"
echo "[INIT]    • Total Événements (Metric)"
echo "[INIT]    • Répartition par Type (Pie Chart)"
echo "[INIT]    • Timeline Réseau (Line Chart)"
echo "[INIT]    • Top 20 Sites Récemment Visités (Table)"
echo "[INIT]    • Requêtes DNS par Heure (Table)"
echo "[INIT] "
echo "[INIT] ✅ Visualisations ARPWatch créées:"
echo "[INIT]    • Total Événements ARP (Metric)"
echo "[INIT]    • ARP Request vs Reply (Pie Chart)"
echo "[INIT]    • Mapping IP-MAC (Table)"
echo "[INIT]    • Top 20 IP ARP (Horizontal Bar)"
echo "[INIT]    • Timeline ARP (Line Chart)"
echo "[INIT] "
echo "[INIT] 🌐 Accédez à Kibana: http://localhost:5601"
echo "[INIT] 📊 Menu → Analytics → Visualize Library"
echo "[INIT] "
echo "[INIT] Pour créer un dashboard:"
echo "[INIT]    1. Analytics → Dashboard → Create dashboard"
echo "[INIT]    2. Add from library → Sélectionner les visualisations"
echo "[INIT]    3. Save dashboard"