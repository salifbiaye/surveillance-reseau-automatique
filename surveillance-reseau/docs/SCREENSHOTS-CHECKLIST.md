<div align="center">

# 📸 Checklist Screenshots & Vidéos — Projet NSOC
### ESP-UCAD | DIC-3-GLSI | Février 2026

</div>

---

> 💡 **INFO :** Toutes les captures sont à placer dans `surveillance-reseau/images/`. Les vidéos sont uploadées sur Google Drive ou YouTube, puis les liens sont insérés dans les `[LIEN_VIDEO_X]` des documents.

---

## 📁 Captures pour `architecture-publique.md`

> 💡 **INFO :** Dans Kibana, les events proviennent de **3 index distincts** selon leur source :
>
> | Index Kibana | Source | Types d'events |
> |-------------|--------|---------------|
> | `suricata-*` | Suricata IDS | dns, tls, alert, http, flow |
> | `arpwatch-*` | ARPWatch | new station, changed mac, flip-flop |
> | `pfsense-*` | pfSense Firewall | règles firewall, NAT, DHCP, trafic bloqué |

### Captures générales

| # | Capture | Nom du fichier | Chemin | ✅ |
|---|---------|---------------|--------|---|
| 1 | Dashboard Nginx NSOC (page d'accueil) | `nsoc-dashboard.png` | `images/nsoc-dashboard.png` | [ ] |
| 2 | Portainer — liste des containers UP | `portainer-containers.png` | `images/portainer-containers.png` | [ ] |

### Captures Kibana — Index `suricata-*`

| # | Capture | Filtre KQL | Nom du fichier | Chemin | ✅ |
|---|---------|-----------|---------------|--------|---|
| 3 | Kibana Discover — Events Suricata : dns | `event_type: "dns"` | `kibana-suricata-dns.png` | `images/kibana-suricata-dns.png` | [ ] |
| 4 | Kibana Discover — Events Suricata : tls | `event_type: "tls"` | `kibana-suricata-tls.png` | `images/kibana-suricata-tls.png` | [ ] |
| 5 | Kibana Discover — Events Suricata : alert | `event_type: "alert"` | `kibana-suricata-alert.png` | `images/kibana-suricata-alert.png` | [ ] |

### Captures Kibana — Index `arpwatch-*`

| # | Capture | Filtre KQL | Nom du fichier | Chemin | ✅ |
|---|---------|-----------|---------------|--------|---|
| 6 | Kibana Discover — Events ARPWatch (nouvelles stations, changements MAC) | *(tout l'index)* | `kibana-arpwatch-events.png` | `images/kibana-arpwatch-events.png` | [ ] |

### Captures Kibana — Index `pfsense-*`

| # | Capture | Filtre KQL | Nom du fichier | Chemin | ✅ |
|---|---------|-----------|---------------|--------|---|
| 7 | Kibana Discover — Logs pfSense Firewall (règles, trafic bloqué) | *(tout l'index)* | `kibana-pfsense-events.png` | `images/kibana-pfsense-events.png` | [ ] |

### Captures Kibana — Dashboards

| # | Capture | Description | Nom du fichier | Chemin | ✅ |
|---|---------|-------------|---------------|--------|---|
| 8 | Kibana Dashboard — Vue d'ensemble (Suricata + ARPWatch + pfSense) | Dashboard global | `kibana-dashboard-1.png` | `images/kibana-dashboard-1.png` | [ ] |
| 9 | Kibana Dashboard — Alertes IDS en temps réel | Dashboard alertes | `kibana-dashboard-2.png` | `images/kibana-dashboard-2.png` | [ ] |

### Captures Arkime

| # | Capture | Nom du fichier | Chemin | ✅ |
|---|---------|---------------|--------|---|
| 10 | Arkime — liste sessions PCAP | `arkime-sessions.png` | `images/arkime-sessions.png` | [ ] |
| 11 | Arkime — détail d'une session | `arkime-detail.png` | `images/arkime-detail.png` | [ ] |

### Instructions captures `architecture-publique.md`

```
1. nsoc-dashboard.png
   → Navigateur sur http://192.168.1.100
   → Plein écran, afficher la page d'accueil complète

2. portainer-containers.png
   → http://192.168.1.100:9000 → Containers
   → Tous les containers visibles (UP), colonnes Name/Status/Ports

--- INDEX suricata-* ---

3. kibana-suricata-dns.png
   → http://192.168.1.100:5601 → Discover → Data view: suricata-*
   → Filtre KQL: event_type: "dns" | Last 15 minutes
   → Champs clés: dns.rrname, src_ip, dest_ip

4. kibana-suricata-tls.png
   → Discover → suricata-* | Filtre: event_type: "tls"
   → Champs clés: tls.sni, src_ip, dest_ip

5. kibana-suricata-alert.png
   → Discover → suricata-* | Filtre: event_type: "alert"
   → Si vide: curl http://testmyids.com depuis le client
   → Champs clés: alert.signature, alert.severity, src_ip

--- INDEX arpwatch-* ---

6. kibana-arpwatch-events.png
   → Discover → Data view: arpwatch-*
   → Pas de filtre (tout afficher) | Last 1 hour
   → Champs clés: event_type (new station / changed mac), ip, mac

--- INDEX pfsense-* ---

7. kibana-pfsense-events.png
   → Discover → Data view: pfsense-*
   → Pas de filtre (tout afficher) | Last 15 minutes
   → Champs clés: action (block/pass), src_ip, dest_ip, dest_port, proto

--- DASHBOARDS ---

8. kibana-dashboard-1.png
   → Analytics → Dashboards → Dashboard global (Suricata + ARPWatch + pfSense)
   → Montrer les panels et graphiques

9. kibana-dashboard-2.png
   → Analytics → Dashboards → Dashboard alertes IDS

--- ARKIME ---

10. arkime-sessions.png
    → http://192.168.1.100:8005 → Sessions
    → Liste des sessions PCAP visible

11. arkime-detail.png
   → Cliquer sur une session → Détail paquet affiché
```

---

## 📁 Captures pour `installation-privee.md`

| # | Capture | Nom du fichier | Chemin | ✅ |
|---|---------|---------------|--------|---|
| 10 | pfSense — page de login | `pfsense-login.png` | `images/pfsense-login.png` | [ ] |
| 11 | pfSense — Dashboard principal (interfaces UP) | `pfsense-dashboard.png` | `images/pfsense-dashboard.png` | [ ] |
| 12 | pfSense — Table ARP (Diagnostics) | `pfsense-arp-table.png` | `images/pfsense-arp-table.png` | [ ] |
| 13 | pfSense — Règles firewall LAN | `pfsense-firewall-rules.png` | `images/pfsense-firewall-rules.png` | [ ] |
| 14 | Machine cliente — `ip addr show` | `client-ip-config.png` | `images/client-ip-config.png` | [ ] |
| 15 | Machine cliente — ping vers pfSense OK | `client-ping-pfsense.png` | `images/client-ping-pfsense.png` | [ ] |
| 16 | Machine cliente — ouverture de l'enseigne NSOC | `client-voir-enseigne.png` | `images/client-voir-enseigne.png` | [ ] |
| 17 | Machine cliente — génération trafic (curl/nslookup) | `client-traffic-gen.png` | `images/client-traffic-gen.png` | [ ] |
| 18 | Kibana — Events **Suricata** filtrés `src_ip:"192.168.1.50"` | `kibana-suricata-client.png` | `images/kibana-suricata-client.png` | [ ] |
| 18b | Kibana — Events **ARPWatch** client (`ip:"192.168.1.50"`) | `kibana-arpwatch-client.png` | `images/kibana-arpwatch-client.png` | [ ] |
| 18c | Kibana — Logs **pfSense** client (`src_ip:"192.168.1.50"`) | `kibana-pfsense-client.png` | `images/kibana-pfsense-client.png` | [ ] |
| 19 | Portainer — logs d'un container (suricata) | `portainer-container-logs.png` | `images/portainer-container-logs.png` | [ ] |
| 20 | Enseigne légale (`/enseigne.html`) | `enseigne-legale.png` | `images/enseigne-legale.png` | [ ] |

### Instructions captures `installation-privee.md`

```
10. pfsense-login.png
    → https://192.168.1.1 → Page de login pfSense

11. pfsense-dashboard.png
    → pfSense → Status → Dashboard
    → Interfaces WAN + LAN visibles et UP

12. pfsense-arp-table.png
    → pfSense → Diagnostics → ARP Table
    → Liste ARP avec IP/MAC du client visible

13. pfsense-firewall-rules.png
    → pfSense → Firewall → Rules → LAN
    → Règles LAN affichées

14. client-ip-config.png
    → Depuis la machine cliente: ip addr show
    → IP 192.168.1.50 visible sur l'interface

15. client-ping-pfsense.png
    → Depuis la machine cliente: ping -c 5 192.168.1.1
    → Réponses OK affichées dans le terminal

16. client-voir-enseigne.png
    → Depuis le navigateur du client: http://192.168.1.100/enseigne.html
    → Page enseigne légale affichée

17. client-traffic-gen.png
    → Terminal client: curl https://www.google.com + nslookup youtube.com
    → Commandes et sorties visibles

18. kibana-suricata-client.png
    → Kibana Discover → Data view: suricata-*
    → Filtre KQL: src_ip:"192.168.1.50"
    → Events Suricata générés par le client (dns, tls, alert)

19. portainer-container-logs.png
    → Portainer → Containers → surveillance-suricata → Logs
    → Logs Suricata affichés en temps réel

20. enseigne-legale.png
    → http://192.168.1.100/enseigne.html
    → Page enseigne complète (depuis Ubuntu NSOC ou client)
```

---

## 🎬 Enregistrements Vidéo

| # | Vidéo | Nom du fichier | Description | Durée cible | ✅ |
|---|-------|---------------|-------------|-------------|---|
| V1 | Démarrage `docker compose up -d` | `video-docker-startup.mp4` | Stack qui démarre, containers UP | ~2 min | [ ] |
| V2 | Client → pfSense → enseigne NSOC | `video-client-connexion.mp4` | Client se connecte, voit l'enseigne | ~2 min | [ ] |
| V3 | Kibana — 3 types d'events en temps réel | `video-kibana-events.mp4` | Navigation dns/tls/alert + filtrage | ~3 min | [ ] |
| V4 | Arkime — analyse PCAP | `video-arkime-pcap.mp4` | Sessions, inspection paquet | ~3 min | [ ] |
| V5 | Alerte Suricata en direct | `video-suricata-alerte.mp4` | Client curl testmyids.com → alerte Kibana | ~2 min | [ ] |
| V6 | Dashboard Kibana avec trafic client | `video-dashboard-client.mp4` | Trafic client → logs apparaissent en direct | ~3 min | [ ] |

### Instructions vidéos

```
V1 — Démarrage Docker
   → Depuis Ubuntu NSOC: docker compose up -d
   → Montrer: téléchargement images, démarrage containers
   → Terminer sur: docker compose ps (tous UP)
   → Upload → remplacer [LIEN_VIDEO_1]

V2 — Connexion client via enseigne
   → Machine cliente: ouvrir navigateur
   → Naviguer vers http://192.168.1.100
   → Montrer l'enseigne légale, puis la page d'accueil NSOC
   → Upload → remplacer [LIEN_VIDEO_2]

V3 — Kibana events en temps réel
   → Kibana Discover → suricata-*
   → Filtrer successivement: dns, tls, alert
   → Montrer les champs, les volumes d'events
   → Upload → remplacer [LIEN_VIDEO_3]

V4 — Arkime PCAP
   → http://192.168.1.100:8005
   → Montrer la liste des sessions
   → Cliquer sur une session → détail paquet
   → Upload → remplacer [LIEN_VIDEO_4]

V5 — Alerte Suricata en direct
   → Deux fenêtres: terminal client + Kibana
   → Client: curl http://testmyids.com
   → Kibana: voir l'alerte apparaître (event_type: alert)
   → Upload → remplacer [LIEN_VIDEO_5]

V6 — Dashboard avec trafic client
   → Client génère du trafic (curl, nslookup)
   → Kibana Dashboard en temps réel: logs apparaissent
   → Montrer la corrélation trafic ↔ events Kibana
   → Upload → remplacer [LIEN_VIDEO_6]
```

---

## 📋 Récapitulatif

| Catégorie | Détail | Total | Fait | Restant |
|-----------|--------|-------|------|---------|
| Captures architecture | Général (2) + Suricata (3) + ARPWatch (1) + pfSense (1) + Dashboards (2) + Arkime (2) | 11 | 0 | 11 |
| Captures installation | pfSense (4) + Client (4) + Kibana 3 index (3) + Portainer (1) + Enseigne (1) | 13 | 0 | 13 |
| Vidéos | V1 à V6 | 6 | 0 | 6 |
| **Total** | | **30** | **0** | **30** |

---

> ⚠️ **ATTENTION :** Après upload des vidéos sur Google Drive / YouTube, remplacer tous les `[LIEN_VIDEO_X]` dans `architecture-publique.md` et `installation-privee.md` par les vraies URLs.

---

**Document:** SCREENSHOTS-CHECKLIST.md | **Version:** 1.0 | **Date:** Février 2026
