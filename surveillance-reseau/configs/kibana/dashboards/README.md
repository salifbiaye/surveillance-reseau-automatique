# Dashboards Kibana Pré-configurés

## 📊 Dashboards Disponibles

### 1. **Vue d'ensemble Réseau** (`network-overview.ndjson`)
**Visualisations:**
- 🥧 **Événements par Type** (Pie Chart)
  - DNS, HTTP, TLS, Alerts, Flow, etc.
  - Permet de voir la répartition du trafic

- 📊 **Top 10 Destinations** (Horizontal Bar)
  - IPs les plus contactées
  - Identifie les destinations principales

- 📈 **Timeline du Trafic** (Line Chart)
  - Évolution du nombre d'événements dans le temps
  - Détecte les pics d'activité

### 2. **Alertes Sécurité** (`security-alerts.ndjson`)
**Visualisations:**
- 🚨 **Compteur d'Alertes** (Metric)
  - Nombre total d'alertes en temps réel

- ⚠️ **Top Alertes par Signature** (Table)
  - Les règles Suricata les plus déclenchées

- 🌍 **Alertes par IP Source** (Tag Cloud)
  - Visualiser les IPs suspectes

### 3. **Surveillance ARP** (`arp-monitoring.ndjson`)
**Visualisations:**
- 🆕 **Nouvelles Stations** (Metric)
  - Nombre de nouveaux devices détectés

- 🔄 **Changements de MAC** (Table)
  - Détection d'ARP spoofing potentiel

- 📍 **Carte IP/MAC** (Data Table)
  - Inventaire complet du réseau

### 4. **Analyse DNS** (`dns-analysis.ndjson`)
**Visualisations:**
- 🔍 **Top Domaines Consultés** (Bar Chart)
  - Sites les plus visités

- 🌐 **Requêtes DNS dans le Temps** (Area Chart)
  - Patterns d'utilisation

- 📋 **Résolutions DNS Suspectes** (Table filtré)
  - Domaines blacklistés ou suspects

---

## 🚀 Import Automatique

Les dashboards sont importés automatiquement au démarrage via le script `init-kibana.sh`.

### Vérifier que les dashboards sont créés:

```bash
# Via l'interface Kibana
1. Ouvrir http://localhost:5601
2. Menu → Analytics → Dashboard
3. Vous devriez voir 4 dashboards

# Via l'API
curl -s http://localhost:5601/api/saved_objects/_find?type=dashboard | jq '.saved_objects[].attributes.title'
```

---

## 📥 Import Manuel (si nécessaire)

Si les dashboards ne sont pas créés automatiquement:

### Méthode 1: Via l'interface Kibana

```
1. Ouvrir Kibana → http://localhost:5601
2. Menu (☰) → Stack Management
3. Kibana → Saved Objects
4. Cliquer "Import"
5. Sélectionner le fichier .ndjson
6. Cliquer "Import"
```

### Méthode 2: Via l'API

```bash
# Importer un dashboard
curl -X POST "http://localhost:5601/api/saved_objects/_import?overwrite=true" \
  -H "kbn-xsrf: true" \
  --form file=@configs/kibana/dashboards/network-overview.ndjson

# Importer tous les dashboards
for file in configs/kibana/dashboards/*.ndjson; do
  curl -X POST "http://localhost:5601/api/saved_objects/_import?overwrite=true" \
    -H "kbn-xsrf: true" \
    --form file=@"$file"
done
```

---

## 🎨 Personnalisation

### Modifier un dashboard existant:

1. Ouvrir le dashboard dans Kibana
2. Cliquer "Edit"
3. Ajouter/Modifier des visualisations
4. Sauvegarder

### Exporter vos modifications:

```
1. Stack Management → Saved Objects
2. Sélectionner le dashboard modifié
3. Cliquer "Export"
4. Télécharger le fichier .ndjson
5. Remplacer le fichier dans configs/kibana/dashboards/
```

---

## 📝 Créer un Nouveau Dashboard

### Via l'interface:

```
1. Analytics → Dashboard → Create dashboard
2. Add visualization → Create new
3. Choisir le type: Bar, Line, Pie, Metric, Table, etc.
4. Source de données: suricata-* ou arpwatch-*
5. Configurer les agrégations et métriques
6. Save and add to dashboard
7. Sauvegarder le dashboard
```

### Visualisations utiles:

| Type | Usage | Exemple |
|------|-------|---------|
| **Metric** | Compteur | Nombre total d'alertes |
| **Pie Chart** | Répartition | % par type d'événement |
| **Bar Chart** | Top N | Top 10 IPs sources |
| **Line Chart** | Évolution | Trafic dans le temps |
| **Data Table** | Liste détaillée | Liste des alertes |
| **Tag Cloud** | Fréquence | Domaines les plus visités |
| **Heatmap** | Corrélations | IP source × destination |

---

## 🔍 Requêtes Utiles (KQL)

### Filtres à utiliser dans les dashboards:

```kql
# Événements DNS uniquement
event_type: "dns"

# Alertes de haute sévérité
event_type: "alert" AND alert.severity: [1 TO 2]

# Trafic vers des IPs externes
NOT dest_ip: 192.168.* AND NOT dest_ip: 10.*

# Requêtes DNS suspectes
dns.rrname: *exe OR dns.rrname: *download OR dns.rrname: *malware

# Nouvelles stations ARP
action: "new_station"

# Changements de MAC (ARP spoofing)
action: "mac_changed"

# Connexions HTTPS
event_type: "tls"

# Trafic HTTP en clair
event_type: "http"
```

---

## 📊 Dashboards Recommandés par Rôle

### 👨‍💼 Manager / Direction
- **Vue d'ensemble Réseau** - Statistiques générales
- Métriques: Nombre d'événements, alertes, trafic

### 🔐 Analyste Sécurité
- **Alertes Sécurité** - Focus sur les menaces
- **Surveillance ARP** - Détection d'attaques réseau

### 🌐 Administrateur Réseau
- **Analyse DNS** - Utilisation réseau
- **Vue d'ensemble Réseau** - Performance

### 🕵️ Forensique
- Tous les dashboards
- + Recherches personnalisées dans Discover

---

## 🎯 Best Practices

### 1. **Rafraîchissement Auto**
- Configurer le rafraîchissement automatique (30s ou 1min)
- Dashboard → Bouton d'horloge en haut à droite

### 2. **Période de Temps**
- Par défaut: Last 24 hours
- Ajuster selon le besoin: Last 1 hour, Last 7 days, etc.

### 3. **Favoris**
- Ajouter les dashboards fréquents en favoris
- Bouton étoile en haut à droite

### 4. **Partage**
- Générer des liens de partage
- Dashboard → Share → Copy link

### 5. **Export**
- Sauvegarder régulièrement les dashboards modifiés
- Stack Management → Saved Objects → Export

---

## 🐛 Troubleshooting

### Problème: Dashboard vide / "No results found"

**Solution:**
```bash
# 1. Vérifier que des données existent
curl -s http://localhost:9200/suricata-*/_count | jq
curl -s http://localhost:9200/arpwatch-*/_count | jq

# 2. Vérifier la période de temps
# Dans Kibana, ajuster le Time Range (en haut à droite)

# 3. Générer du trafic de test
ping -c 10 google.com
curl https://youtube.com

# Attendre 30 secondes et rafraîchir Kibana
```

### Problème: Dashboard ne s'importe pas

**Solution:**
```bash
# Vérifier que Kibana est accessible
curl http://localhost:5601/api/status

# Réimporter avec force
curl -X POST "http://localhost:5601/api/saved_objects/_import?overwrite=true" \
  -H "kbn-xsrf: true" \
  --form file=@configs/kibana/dashboards/network-overview.ndjson
```

### Problème: Visualisations cassées

**Solution:**
1. Vérifier que les Data Views existent:
   - Stack Management → Data Views
   - Doit avoir: suricata-* et arpwatch-*

2. Re-créer le Data View si nécessaire:
   ```bash
   docker compose restart kibana-init
   ```

---

## 📚 Ressources

- [Kibana Dashboard Documentation](https://www.elastic.co/guide/en/kibana/current/dashboard.html)
- [Kibana Visualizations](https://www.elastic.co/guide/en/kibana/current/dashboard-create-new-visualization.html)
- [KQL Query Language](https://www.elastic.co/guide/en/kibana/current/kuery-query.html)

---

**Version:** 2.1
**Dernière mise à jour:** 2026-02-14
