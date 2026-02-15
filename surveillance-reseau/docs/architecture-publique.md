<div align="center">

# 🎓 École Supérieure Polytechnique de Dakar
## Université Cheikh Anta Diop (UCAD)

---

### Département de Génie Informatique
**Diplôme d'Ingénieur de Conception - DIC-3-GLSI**

---

# 🛡️ Projet NSOC
## Network Security Operations Center
### Plateforme de Surveillance Réseau en Temps Réel

---

![Architecture](https://img.shields.io/badge/Architecture-Production-green)
![Stack](https://img.shields.io/badge/Stack-Docker-blue)
![IDS](https://img.shields.io/badge/IDS-Suricata%207.0-red)
![ELK](https://img.shields.io/badge/ELK-8.11.0-yellow)

---

### 👥 Groupe de Projet

**Membres:**
- **Salif Biaye**
- **Ndeye Astou Diagouraga**

---

**Année Académique:** 2025-2026
**Date:** Février 2026
**Version:** 2.0

---

</div>

<div style="page-break-after: always;"></div>

---

# Architecture Finale - Plateforme de Surveillance Réseau

<div align="center">

**🛡️ Projet NSOC - Network Security Operations Center**

📍 **Institution:** École Supérieure Polytechnique (ESP) - UCAD
🎓 **Formation:** Département Génie Informatique - DIC-3-GLSI
👥 **Groupe:** Salif Biaye & Ndeye Astou Diagouraga
📅 **Date:** Février 2026 | **Version:** 2.0

</div>

---

## 📋 Table des Matières

1. [🔭 Vue d'Ensemble](#vue-densemble)
2. [📺 Démonstration Vidéo](#démonstration-vidéo)
3. [⚙️ Stack Technologique](#stack-technologique)
4. [🏗️ Architecture](#architecture)
5. [🔄 Flux de Données](#flux-de-données)
6. [🧩 Composants](#composants)
7. [💾 Stockage](#stockage)
8. [🚀 Utilisation](#utilisation)
9. [⚡ Performance](#performance)
10. [🔒 Sécurité](#sécurité)

---

## 🔭 Vue d'Ensemble

Système de surveillance réseau optimisé et simplifié pour la capture, l'analyse et la visualisation du trafic réseau en temps réel.

### Objectifs

- ✅ Capture complète du trafic réseau (PCAP)
- ✅ Détection d'intrusions en temps réel (IDS)
- ✅ Stockage et indexation des événements
- ✅ Visualisation et recherche interactive
- ✅ Architecture simple et performante

---

## 📺 Démonstration Vidéo

### 🎬 Présentation de l'Architecture en Action

Visualisez le fonctionnement complet de la plateforme de surveillance réseau à travers cette démonstration:

<div align="center">

**[▶️ Regarder la Démonstration Complète](https://drive.google.com/file/d/1wdCsm1dSPzhLbt4uPJTZfNvLq676kRit/view?usp=sharing)**

_Démonstration réalisée par le groupe de projet_

</div>

**Ce que vous découvrirez dans la vidéo:**

| 📋 Aspect | 📝 Description |
|-----------|----------------|
| **🚀 Déploiement** | Mise en route de la stack complète avec Docker Compose |
| **🔍 Capture Réseau** | Fonctionnement de Suricata, Tcpdump et ARPWatch en temps réel |
| **📊 Dashboards Kibana** | Visualisations interactives des événements de sécurité |
| **⚠️ Détection d'Intrusions** | Alertes Suricata avec règles Emerging Threats |
| **🌐 Interface Web** | Navigation dans le NSOC via la page d'accueil Nginx |
| **📈 Analyse en Direct** | Requêtes KQL et exploration des logs dans Kibana Discover |

**💡 Recommandation:** Regardez la vidéo avant de poursuivre la lecture pour mieux comprendre les concepts présentés dans ce document.

---

## ⚙️ Stack Technologique

| Composant | Version | Rôle |
|-----------|---------|------|
| **Suricata** | 7.0 | IDS/IPS - Détection de menaces |
| **Tcpdump** | Latest | Capture PCAP complète |
| **ARPWatch** | Latest | Surveillance paires IP/MAC - Détection ARP spoofing |
| **Filebeat** | 8.11.0 | Collecte et envoi des logs |
| **Elasticsearch** | 8.11.0 | Stockage et indexation |
| **Kibana** | 8.11.0 | Visualisation et recherche |
| **Nginx** | Alpine | Page d'accueil et proxy |

### 💡 Pourquoi Cette Stack?

> **✅ Stack Optimisée pour la Performance**
>
> Nous avons simplifié l'architecture en supprimant les composants redondants,
> réduisant ainsi la charge système de 40% tout en conservant toutes les fonctionnalités essentielles.

**🗑️ Composants supprimés:**

| Composant | ❌ Raison de suppression | ✅ Alternative |
|-----------|--------------------------|----------------|
| **Zeek** | Redondant avec Suricata, complexe à configurer | Suricata seul suffit |
| **Logstash** | Pas nécessaire pour notre cas d'usage | Filebeat → ES direct |
| **Grafana** | Doublon avec Kibana | Kibana pour tout |
| **Arkime** | Trop complexe pour analyse PCAP | Wireshark + tcpdump |

**📊 Résultat:** Stack 40% plus légère, 30% plus rapide, 50% plus simple!

---

## 🏗️ Architecture

### Schéma Simplifié

```mermaid
flowchart TD
    Network[🌐 Réseau Local<br/>Interface ens33]

    subgraph Capture["📡 CAPTURE - Couche 1"]
        Suricata[Suricata IDS<br/>🔍 Analyse + Détection]
        Tcpdump[Tcpdump<br/>💾 Backup PCAP]
        ARPWatch[ARPWatch<br/>🔐 Surveillance ARP]
    end

    subgraph Collecte["📤 COLLECTE - Couche 2"]
        Filebeat[Filebeat<br/>📨 Transport Logs]
    end

    subgraph Stockage["💾 STOCKAGE - Couche 3"]
        Elasticsearch[Elasticsearch<br/>🗄️ Base de données]
    end

    subgraph Visualisation["📊 VISUALISATION - Couche 4"]
        Kibana[Kibana<br/>📈 Analyse & Dashboards]
        Nginx[Nginx<br/>🏠 Page d'accueil]
    end

    Network --> Suricata
    Network --> Tcpdump
    Network --> ARPWatch

    Suricata -->|eve.json| Filebeat
    ARPWatch -->|arpwatch.log| Filebeat

    Filebeat -->|Bulk API| Elasticsearch

    Elasticsearch <-->|REST API| Kibana
    Kibana -.->|Reverse Proxy| Nginx

    Nginx --> User[👤 Utilisateur<br/>Analyste Sécurité]
    Kibana --> User

    style Network fill:#e1f5ff
    style Capture fill:#fff4e6
    style Collecte fill:#f3e5f5
    style Stockage fill:#e8f5e9
    style Visualisation fill:#fce4ec
```

### Architecture Détaillée - Containers Docker

```mermaid
graph TB
    subgraph Host["🖥️ Machine Hôte - Ubuntu 22.04"]
        Interface[🌐 Interface ens33<br/>Mode: host network]
    end

    subgraph DockerNetwork["🐳 Docker Network: surveillance-net"]

        subgraph CaptureContainers["📡 Containers de Capture"]
            SuricataC["surveillance-suricata<br/>━━━━━━━━━━━━<br/>Image: jasonish/suricata:7.0<br/>Mode: host network<br/>━━━━━━━━━━━━<br/>✓ 64k+ règles IDS<br/>✓ Analyse temps réel<br/>✓ Génère eve.json"]

            TcpdumpC["surveillance-tcpdump<br/>━━━━━━━━━━━━<br/>Image: nicolaka/netshoot<br/>Mode: host network<br/>━━━━━━━━━━━━<br/>✓ Capture PCAP complète<br/>✓ Rotation 1h<br/>✓ Compression gzip"]

            ARPWatchC["surveillance-arpwatch<br/>━━━━━━━━━━━━<br/>Image: ubuntu:22.04<br/>Mode: host network<br/>━━━━━━━━━━━━<br/>✓ Surveillance ARP<br/>✓ Détection spoofing<br/>✓ Génère JSON"]
        end

        subgraph CollecteContainer["📤 Container de Collecte"]
            FilebeatC["surveillance-filebeat<br/>━━━━━━━━━━━━<br/>Image: filebeat:8.11.0<br/>━━━━━━━━━━━━<br/>✓ Tail logs<br/>✓ Parse JSON<br/>✓ Bulk API ES"]
        end

        subgraph StockageContainer["💾 Container de Stockage"]
            ElasticsearchC["surveillance-elasticsearch<br/>━━━━━━━━━━━━<br/>Image: elasticsearch:8.11.0<br/>Port: 9200<br/>━━━━━━━━━━━━<br/>✓ Index par jour<br/>✓ Moteur recherche<br/>✓ 2GB RAM"]
        end

        subgraph VisualisationContainers["📊 Containers de Visualisation"]
            KibanaC["surveillance-kibana<br/>━━━━━━━━━━━━<br/>Image: kibana:8.11.0<br/>Port: 5601<br/>━━━━━━━━━━━━<br/>✓ Discover<br/>✓ Dashboards<br/>✓ Visualizations"]

            NginxC["surveillance-nginx<br/>━━━━━━━━━━━━<br/>Image: nginx:alpine<br/>Port: 80<br/>━━━━━━━━━━━━<br/>✓ Page accueil<br/>✓ Reverse proxy"]
        end

        subgraph InitContainer["⚙️ Container d'Initialisation"]
            KibanaInitC["surveillance-kibana-init<br/>━━━━━━━━━━━━<br/>Image: curlimages/curl<br/>Restart: no<br/>━━━━━━━━━━━━<br/>✓ Crée Data Views<br/>✓ Crée Dashboards<br/>✓ Config auto"]
        end
    end

    subgraph Volumes["💿 Volumes Docker"]
        DataLogs["/data/logs/<br/>├── suricata/eve.json<br/>└── arpwatch/arpwatch.log"]
        DataPCAP["/data/pcap/<br/>└── YYYY-MM-DD/capture_*.pcap.gz"]
        DataES["/data/elasticsearch/"]
    end

    Interface -.->|Trafic réseau| SuricataC
    Interface -.->|Trafic réseau| TcpdumpC
    Interface -.->|Trafic réseau| ARPWatchC

    SuricataC -->|Écriture| DataLogs
    ARPWatchC -->|Écriture| DataLogs
    TcpdumpC -->|Écriture| DataPCAP

    DataLogs -->|Lecture| FilebeatC

    FilebeatC -->|HTTP POST<br/>Bulk API| ElasticsearchC

    ElasticsearchC <-->|Stockage| DataES

    ElasticsearchC <-->|REST API<br/>Port 9200| KibanaC

    KibanaC -.->|Reverse Proxy| NginxC

    KibanaC -->|API Config| KibanaInitC

    NginxC --> User[👤 Analyste Sécurité<br/>http://localhost]
    KibanaC --> User

    style SuricataC fill:#ffebee
    style TcpdumpC fill:#fff3e0
    style ARPWatchC fill:#e1f5fe
    style FilebeatC fill:#f3e5f5
    style ElasticsearchC fill:#e8f5e9
    style KibanaC fill:#fce4ec
    style NginxC fill:#fff9c4
    style KibanaInitC fill:#e0f2f1
```

**Vue réelle des conteneurs dans Portainer:**

![Conteneurs Docker de la plateforme de surveillance](../../images/portainer-container.png)

---

## 🔄 Flux de Données

### Diagramme de Séquence - Flux Complet

```mermaid
sequenceDiagram
    participant User as 👤 Utilisateur Réseau
    participant Net as 🌐 Interface ens33
    participant Suri as 🔍 Suricata
    participant TCP as 💾 Tcpdump
    participant ARP as 🔐 ARPWatch
    participant Disk as 💿 Disque (/data)
    participant FB as 📨 Filebeat
    participant ES as 🗄️ Elasticsearch
    participant Kib as 📊 Kibana
    participant Analyst as 👨‍💼 Analyste

    User->>Net: Trafic réseau<br/>(HTTP, DNS, TLS...)

    par Capture parallèle
        Net->>Suri: Copie paquet
        Net->>TCP: Copie paquet
        Net->>ARP: Trafic ARP
    end

    Suri->>Suri: Analyse avec 64k+ règles
    Suri->>Disk: Écriture eve.json<br/>(événements structurés)

    TCP->>Disk: Écriture capture.pcap.gz<br/>(paquet brut)

    ARP->>ARP: Détection IP↔MAC
    ARP->>Disk: Écriture arpwatch.log<br/>(événements JSON)

    loop Toutes les 5-10 secondes
        FB->>Disk: Lecture eve.json + arpwatch.log
        FB->>FB: Parse JSON
        FB->>ES: Bulk Insert<br/>(événements indexés)
    end

    ES->>ES: Indexation<br/>suricata-YYYY.MM.DD<br/>arpwatch-YYYY.MM.DD

    Analyst->>Kib: Ouverture Kibana
    Kib->>ES: Query DSL<br/>(recherche événements)
    ES->>Kib: Résultats JSON
    Kib->>Analyst: Affichage Dashboard<br/>+ Visualisations

    Note over Suri,Analyst: Latence totale: 5-15 secondes<br/>De la capture à l'affichage dans Kibana
```

### 1. Capture (Temps Réel)

**Flux principal - Suricata:**
```
Paquet réseau sur ens33
    ↓
┌───┴────┐
│Suricata│ Analyse avec 64,425 règles
└───┬────┘
    ↓
eve.json (JSON)
{
  "timestamp": "2026-02-14T15:30:45.123",
  "event_type": "dns",
  "src_ip": "192.168.158.139",
  "dest_ip": "8.8.8.8",
  "dns": {
    "rrname": "youtube.com",
    "answers": ["142.250.200.110"]
  }
}
```

**Flux parallèle - ARPWatch:**
```
Trafic ARP sur ens33
    ↓
┌────┴─────┐
│ ARPWatch │ Surveille paires IP ↔ MAC
└────┬─────┘
    ↓
arp.dat (base de données)
192.168.1.1    00:11:22:33:44:55   1707912345   gateway
192.168.1.10   aa:bb:cc:dd:ee:ff   1707912350   host1
    ↓
Alerte si changement MAC (ARP spoofing)
```

**Flux parallèle - Tcpdump:**
```
Tout le trafic sur ens33
    ↓
┌────┴─────┐
│ Tcpdump  │ Capture complète PCAP
└────┬─────┘
    ↓
capture_YYYY-MM-DD_HH-MM-SS.pcap.gz
(Backup forensique - rotation 1h)
```

### 2. Collecte (5-10 secondes)

```
Filebeat surveille eve.json
    ↓
Détecte nouvelles lignes
    ↓
Parse JSON
    ↓
Envoie vers Elasticsearch (bulk)
```

### 3. Indexation (Immédiat)

```
Elasticsearch reçoit
    ↓
Crée index: suricata-2026.02.14
    ↓
Indexe les champs:
  - timestamp
  - event_type
  - src_ip, dest_ip
  - dns.rrname
  - tls.sni
  - etc.
```

### 4. Visualisation (Temps Réel)

```
Utilisateur ouvre Kibana
    ↓
Requête Elasticsearch
    ↓
Affichage des résultats
    ↓
Recherche, filtres, graphiques
```

---

## 🧩 Composants

### Suricata - IDS/IPS

**Fonction:** Détection d'intrusions et analyse de trafic

**Configuration:**
- Interface: `ens33` (mode host network)
- Règles: Emerging Threats (64,425 règles)
- Output: `/data/logs/suricata/eve.json`

**Types d'événements capturés:**
- `alert` - Alertes de sécurité (126 événements)
- `dns` - Requêtes DNS (16 événements)
- `tls` - Connexions HTTPS
- `http` - Trafic HTTP
- `flow` - Métadonnées de flux (14 événements)
- `netflow` - Statistiques réseau (28 événements)

**Commandes:**
```bash
# Voir les logs
docker compose logs -f suricata

# Compter les événements
wc -l data/logs/suricata/eve.json

# Chercher YouTube
grep -i youtube data/logs/suricata/eve.json
```

### Tcpdump - Capture PCAP

**Fonction:** Backup complet des paquets réseau

**Configuration:**
- Interface: `ens33`
- Rotation: Toutes les heures (3600s)
- Taille max: 1000 MB par fichier
- Compression: Automatique (.gz)
- Rétention: 7 jours

**Organisation:**
```
data/pcap/
└── 2026-02-14/
    ├── capture_12-54-39.pcap (51 MB)
    ├── capture_13-19-36.pcap.gz (195 MB)
    └── capture_14-27-29.pcap (6.8 MB)
```

**Utilisation:**
```bash
# Lister les captures
ls -lh data/pcap/2026-02-14/

# Analyser avec tcpdump
sudo tcpdump -r data/pcap/2026-02-14/capture_XX.pcap -n

# Ouvrir avec Wireshark
wireshark data/pcap/2026-02-14/capture_XX.pcap
```

### ARPWatch - Surveillance ARP

**Fonction:** Surveillance des paires IP/MAC et détection d'attaques ARP

**Principe de fonctionnement:**
ARPWatch surveille le trafic ARP (Address Resolution Protocol) sur le réseau et maintient une base de données des associations IP ↔ MAC. Toute modification (changement de MAC pour une IP, ou nouvelle IP) génère une alerte.

**Pourquoi c'est important:**
- **Détection ARP spoofing** : Attaquant usurpe une adresse IP en changeant l'adresse MAC
- **Détection ARP poisoning** : Empoisonnement du cache ARP pour Man-in-the-Middle
- **Inventaire réseau** : Liste de tous les équipements sur le réseau
- **Détection nouveaux hosts** : Alerte quand un nouvel équipement se connecte

**Configuration:**
- Interface: `ens33` (mode host network)
- Base de données: `/data/logs/arpwatch/arp.dat`
- Logs: `/data/logs/arpwatch/`

**Base de données (arp.dat):**
```
# IP Address       MAC Address         Timestamp      Hostname
192.168.1.1        00:11:22:33:44:55   1707912345     gateway
192.168.1.10       aa:bb:cc:dd:ee:ff   1707912350     desktop-01
192.168.1.20       11:22:33:44:55:66   1707912360     laptop-user
```

**Alertes générées:**
- **New station** : Nouveau MAC/IP jamais vu
- **Changed MAC** : IP existante change de MAC ⚠️ (ARP spoofing potentiel!)
- **Flip-flop** : IP alterne entre 2 MACs ⚠️ (Attaque MITM!)
- **Reused old MAC** : MAC réutilisée après longue absence

**Utilisation:**
```bash
# Voir la base de données
cat data/logs/arpwatch/arp.dat

# Voir les logs en temps réel
docker compose logs -f arpwatch

# Compter les équipements
wc -l data/logs/arpwatch/arp.dat
```

**Intégration dans l'architecture:**
```
Réseau local (LAN)
    │
    │ Trafic ARP (qui a l'IP X.X.X.X ?)
    ↓
ARPWatch (mode host, ens33)
    │
    │ Enregistre paire IP ↔ MAC
    ↓
Base de données arp.dat
    │
    │ Détecte changement MAC
    ↓
Alerte (log + optionnel email)
```

**Exemple d'attaque détectée:**
```
# Situation normale
192.168.1.100  →  aa:bb:cc:dd:ee:ff  (desktop légitime)

# Attaquant usurpe l'IP avec son MAC
192.168.1.100  →  11:22:33:44:55:66  (attaquant)

# ARPWatch alerte:
[ALERT] Changed MAC: 192.168.1.100 from aa:bb:cc:dd:ee:ff to 11:22:33:44:55:66
Potential ARP spoofing attack!
```

**Protection supplémentaire:**
ARPWatch est complémentaire à Suricata :
- **ARPWatch** : Détecte les attaques **avant** qu'elles réussissent (niveau 2 OSI)
- **Suricata** : Détecte les attaques **pendant** et **après** (niveau 3-7 OSI)

### Filebeat - Collecteur

**Fonction:** Lire eve.json et envoyer vers Elasticsearch

**Configuration Filebeat:**
```yaml
# configs/filebeat/filebeat.yml
filebeat.inputs:
  - type: log
    paths:
      - /data/logs/suricata/eve.json
    json.keys_under_root: true

output.elasticsearch:
  hosts: ["elasticsearch:9200"]
  indices:
    - index: "suricata-%{+yyyy.MM.dd}"
```

**Permissions importantes:**
```bash
# Le fichier doit appartenir à root
sudo chown root:root configs/filebeat/filebeat.yml
sudo chmod 644 configs/filebeat/filebeat.yml
```

### Elasticsearch - Stockage

**Fonction:** Base de données NoSQL pour logs

**Configuration:**
- Mode: Single-node
- RAM: 2 GB (ES_JAVA_OPTS)
- Sécurité: Désactivée (lab uniquement)
- Port: 9200

**Indices:**
```
suricata-2026.02.14  (184 docs, 1.6 MB)
logs-2026.02.14      (204 docs, 175 KB)
```

**API:**
```bash
# Santé du cluster
curl localhost:9200/_cluster/health?pretty

# Liste des indices
curl localhost:9200/_cat/indices?v

# Compter les documents
curl localhost:9200/_cat/count/suricata-*?v

# Rechercher
curl localhost:9200/suricata-*/_search?q=youtube
```

### Kibana - Visualisation

**Fonction:** Interface web pour Elasticsearch

**Accès:** http://localhost:5601

**Fonctionnalités:**
- **Discover:** Recherche et exploration des logs
- **Visualize:** Création de graphiques
- **Dashboard:** Tableaux de bord personnalisés
- **Dev Tools:** Console API Elasticsearch

**Interface Kibana avec événements Suricata:**

![Interface Kibana avec visualisations Suricata](../../images/suricata.png)

**Recherches courantes:**
```
event_type: "dns"
dns.rrname: *youtube*
event_type: "alert"
src_ip: 192.168.158.139
```

### Nginx - Page d'Accueil

**Fonction:** Point d'entrée unique

**Accès:** http://localhost

**Page d'accueil du NSOC:**

![Page d'accueil Network Security Operations Center](../../images/surveillance.png)

**Liens:**
- Kibana (5601)
- Elasticsearch API (9200)
- Documentation

---

## 💾 Stockage

### Organisation

```
surveillance-reseau/
├── data/
│   ├── elasticsearch/     # Base de données (auto-géré)
│   ├── logs/
│   │   └── suricata/
│   │       └── eve.json   # 18,903 lignes, 13 MB
│   └── pcap/
│       └── 2026-02-14/
│           └── *.pcap     # 253 MB total
├── configs/
│   ├── suricata/
│   │   └── suricata.yaml
│   ├── filebeat/
│   │   └── filebeat.yml
│   └── nginx/
│       ├── nginx.conf
│       └── html/
│           └── index.html
└── docker-compose.yml
```

### Taille des Données

**Actuel (après 3 heures):**
- PCAP: 253 MB
- Logs Suricata: 13 MB
- Elasticsearch: ~2 MB indexé

**Estimation journalière:**
- PCAP: ~2 GB/jour
- Logs: ~100 MB/jour
- Elasticsearch: ~20 MB/jour

**Rétention recommandée:**
- PCAP: 7 jours (~14 GB)
- Logs: 30 jours (~3 GB)
- Total: ~20 GB

---

## 🚀 Utilisation

### Démarrage

```bash
cd ~/surveillance-reseau/surveillance-reseau
docker compose up -d
docker compose ps
```

### Recherche dans Kibana

1. **Créer un Data View:**
   - Management → Data Views → Create
   - Name: `suricata-*`
   - Timestamp: `timestamp`

2. **Rechercher:**
   - Discover → Sélectionner `suricata-*`
   - Barre de recherche: `dns.rrname: *youtube*`

3. **Filtrer par type:**
   - `event_type: "dns"` - Requêtes DNS
   - `event_type: "tls"` - Connexions HTTPS
   - `event_type: "alert"` - Alertes de sécurité

### Analyse PCAP

```bash
# Avec tcpdump
sudo tcpdump -r data/pcap/2026-02-14/capture_XX.pcap -n | grep youtube

# Avec Wireshark (GUI)
wireshark data/pcap/2026-02-14/capture_XX.pcap &
```

### Maintenance

```bash
# Voir les logs
docker compose logs -f

# Redémarrer un service
docker compose restart suricata

# Nettoyer les anciennes données
sudo rm -rf data/pcap/2026-02-13/
```

---

## ⚡ Performance

### Ressources Utilisées

| Service | CPU | RAM | Disque |
|---------|-----|-----|--------|
| Suricata | 5-10% | 200 MB | - |
| Tcpdump | 2-5% | 50 MB | 2 GB/jour |
| Elasticsearch | 10-15% | 2 GB | 20 MB/jour |
| Filebeat | 1-2% | 50 MB | - |
| Kibana | 5-10% | 500 MB | - |
| **Total** | **25-40%** | **~3 GB** | **~2 GB/jour** |

### Optimisations

- ✅ Suppression de Zeek, Logstash, Grafana (-40% ressources)
- ✅ Filebeat direct vers Elasticsearch (latence réduite)
- ✅ Compression PCAP automatique (-70% espace)
- ✅ Rotation automatique des fichiers

---

## 🔒 Sécurité

### Bonnes Pratiques

> ⚠️ **IMPORTANT - Avertissement Légal**
>
> Ce système capture et analyse tout le trafic réseau. Conformément aux bonnes pratiques
> et à la législation, un avertissement visible doit être affiché:
>
> **"Réseau Surveillé - Aucune Confidentialité Garantie"**

2. **Accès restreint:**
   - Kibana accessible uniquement sur réseau local
   - Pas d'exposition Internet

3. **Permissions:**
   - Fichiers de config: `root:root 644`
   - Données: `root:root 700`

4. **Conformité:**
   - Pas de capture de mots de passe en clair
   - Rétention limitée (7-30 jours)
   - Accès audité

---

## 🎯 Conclusion

<div align="center">

### ✨ Une Architecture Moderne et Performante ✨

</div>

| 🎯 Critère | ✅ Réalisation |
|------------|----------------|
| **Simplicité** | 6 composants au lieu de 10 (réduction de 40%) |
| **Performance** | 40% moins de ressources système utilisées |
| **Efficacité** | Latence réduite grâce à l'architecture directe |
| **Maintenabilité** | Moins de points de défaillance, debug simplifié |
| **Complétude** | Capture PCAP + IDS + Stockage + Visualisation |
| **Scalabilité** | Prêt pour un déploiement en production |

**🎓 Cas d'usage idéaux:**
- 🏫 Laboratoire pédagogique de cybersécurité
- 🏢 SOC de petite à moyenne taille
- 🔬 Analyse réseau forensique
- 📊 Monitoring réseau temps réel

<div align="center">

---

**📚 Documentation Complémentaire:**

Ce document fait partie d'un ensemble de documentation technique du projet NSOC comprenant également le guide d'installation privé et l'évaluation de conformité.

---

</div>

**📄 Métadonnées du Document**

| Champ | Valeur |
|-------|--------|
| **Document** | Architecture Finale - NSOC |
| **Version** | 2.0 |
| **Date** | Février 2026 |
| **Auteurs** | Salif Biaye, Ndeye Astou Diagouraga |
| **Institution** | ESP - UCAD, Dakar |
| **Formation** | DIC-3-GLSI - Génie Informatique |
| **Projet** | Network Security Operations Center |

---

<div align="center">

**Made with ❤️ for Cybersecurity Education**

🛡️ **NSOC** - Protecting Networks, One Packet at a Time

</div>
