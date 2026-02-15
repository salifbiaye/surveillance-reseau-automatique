# 📸 Répartition des Screenshots - Projet NSOC

Ce fichier documente comment les screenshots existants ont été répartis entre les documents du projet NSOC.

---

## 🎯 Principe de Répartition

**Objectif:** Éviter la duplication excessive des screenshots entre `architecture-publique.md` et `installation-privee.md`.

**Stratégie:**
- **architecture-publique.md** - Document général sur l'architecture → Screenshots de vue d'ensemble
- **installation-privee.md** - Guide pratique d'installation → Screenshots spécifiques aux étapes d'installation

---

## 📁 Screenshots Disponibles (7 fichiers)

| Fichier | Taille | Utilisation |
|---------|--------|-------------|
| `captiveportal.png` | 123 KB | Installation (pfSense config) |
| `enseigne.png` | 144 KB | Installation (topologie réseau) |
| `library.png` | 203 KB | Installation (architecture lab) |
| `login pfsense.png` | 227 KB | Installation (interface pfSense) |
| `portainer-container.png` | 205 KB | **Partagé** (Architecture + Installation) |
| `suricata.png` | 238 KB | **Partagé** (Architecture + Installation) |
| `surveillance.png` | 165 KB | Architecture (page d'accueil) |

**Total:** ~1.3 MB

---

## 📄 Répartition par Document

### 1. architecture-publique.md

**Screenshots utilisés (3):**

| Screenshot | Ligne | Section | Contexte |
|------------|-------|---------|----------|
| `portainer-container.png` | 278 | Conteneurs Docker | Vue d'ensemble de l'architecture des conteneurs |
| `suricata.png` | 636 | Interface Kibana | Visualisations et dashboards Suricata |
| `surveillance.png` | 654 | Page d'accueil NSOC | Interface principale de la plateforme |

**Justification:**
- Document architectural → focus sur la vue d'ensemble du système
- Screenshots montrant le résultat final opérationnel
- Illustrations des composants clés (Docker, Kibana, Interface)

---

### 2. installation-privee.md

**Screenshots utilisés (6):**

| Screenshot | Section | Contexte |
|------------|---------|----------|
| `library.png` | 1. Architecture | Diagramme d'architecture des 3 machines |
| `enseigne.png` | 2. Schéma Réseau | Topologie réseau avec plan d'adressage IP |
| `login pfsense.png` | PARTIE 1 (4.2) | Interface web pfSense - Accès admin |
| `captiveportal.png` | PARTIE 1 (4.2.2) | Configuration port mirroring |
| `portainer-container.png` | PARTIE 2 (7.4.1) | Vérification démarrage conteneurs |
| `suricata.png` | PARTIE 2 (7.6.1) | Interface Kibana - Vérification captures |

**Justification:**
- Guide d'installation pratique → screenshots des étapes concrètes
- Images montrant comment accéder et configurer chaque composant
- Illustrations des points de vérification (Portainer, Kibana)

---

## 🔄 Screenshots Partagés (2)

### `portainer-container.png`

**Utilisé dans les deux documents car:**
- **Architecture:** Montre la structure générale des conteneurs Docker
- **Installation:** Point de vérification essentiel après déploiement

**Contexte différent:**
- Architecture → "Voici comment est organisée la plateforme"
- Installation → "Voici comment vérifier que l'installation a réussi"

### `suricata.png`

**Utilisé dans les deux documents car:**
- **Architecture:** Illustre les capacités de visualisation Kibana
- **Installation:** Point de vérification des événements capturés

**Contexte différent:**
- Architecture → "Voici les visualisations disponibles"
- Installation → "Voici comment vérifier que la capture fonctionne"

---

## ✅ Screenshots Uniques par Document

### architecture-publique.md uniquement

- ✅ `surveillance.png` - Page d'accueil (vue d'ensemble du système)

### installation-privee.md uniquement

- ✅ `library.png` - Architecture lab
- ✅ `enseigne.png` - Topologie réseau
- ✅ `login pfsense.png` - Accès pfSense
- ✅ `captiveportal.png` - Configuration port mirroring

---

## 📊 Statistiques d'Utilisation

| Document | Screenshots totaux | Screenshots uniques | Screenshots partagés |
|----------|-------------------|---------------------|---------------------|
| **architecture-publique.md** | 3 | 1 (surveillance.png) | 2 |
| **installation-privee.md** | 6 | 4 | 2 |
| **Total unique** | - | 5 | 2 |

**Taux de duplication:** 2/7 = 28.6% (acceptable pour la cohérence documentaire)

---

## 🎯 Bénéfices de cette Répartition

### ✅ Avantages

1. **Évite la redondance excessive** - Seulement 2 screenshots partagés avec contexte différent
2. **Cohérence documentaire** - Chaque document a son propre focus visuel
3. **Utilisation optimale** - Tous les 7 screenshots disponibles sont utilisés
4. **Navigation claire** - Les lecteurs voient des images pertinentes au contexte

### 📈 Amélioration vs Plan Initial

**Plan initial (SCREENSHOTS_A_AJOUTER.md):**
- 12 nouveaux screenshots à créer
- Total: 15 screenshots (3 existants + 12 nouveaux)

**Réalité après adaptation:**
- 7 screenshots existants réutilisés intelligemment
- Aucun nouveau screenshot requis
- Réduction de 53% du besoin en images

---

## 🔍 Mapping des Références

### architecture-publique.md

```markdown
Ligne 278: ![Conteneurs Docker](../../images/portainer-container.png)
Ligne 636: ![Interface Kibana](../../images/suricata.png)
Ligne 654: ![Page d'accueil NSOC](../../images/surveillance.png)
```

### installation-privee.md

```markdown
Section 1.1:   ![Architecture lab](../../images/library.png)
Section 2.1:   ![Topologie réseau](../../images/enseigne.png)
Section 4.2:   ![Interface pfSense](../../images/login pfsense.png)
Section 4.2.2: ![Port mirroring](../../images/captiveportal.png)
Section 7.4.1: ![Conteneurs Docker](../../images/portainer-container.png)
Section 7.6.1: ![Interface Kibana](../../images/suricata.png)
```

---

## 📝 Recommandations Futures

### Si de nouveaux screenshots sont créés

**Pour architecture-publique.md:**
- Diagrammes d'architecture système haute résolution
- Schémas de flux de données détaillés
- Captures d'écran de dashboards Kibana personnalisés

**Pour installation-privee.md:**
- Terminal montrant `docker compose up -d` en cours
- Output de `docker ps` avec les 6 conteneurs
- Configuration réseau de la machine cliente
- Événements du client dans Kibana avec filtres

### Principe de non-duplication

**Ajouter un screenshot seulement si:**
1. Il apporte une valeur ajoutée unique au document
2. Il n'existe pas déjà un screenshot similaire dans l'autre document
3. Le contexte d'utilisation est significativement différent

---

**📅 Date de documentation:** 15 février 2026
**👥 Auteurs:** Salif Biaye & Ndeye Astou Diagouraga
**📋 Projet:** NSOC - Optimisation Documentation
**✅ Status:** Répartition complète et optimisée
