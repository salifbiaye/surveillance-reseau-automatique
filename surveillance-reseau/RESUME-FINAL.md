# Résumé de la plateforme de surveillance réseau

## ✅ Ce qui fonctionne

### Services déployés
- **Suricata** : IDS/IPS + génération de logs (eve.json)
- **Tcpdump** : Capture PCAP brute
- **ARPWatch** : Surveillance MAC/IP
- **Elasticsearch** : Stockage centralisé avec authentification
- **Kibana** : Dashboards et visualisation (avec login)
- **Filebeat** : Collecte et envoi des logs
- **Arkime** : Analyse PCAP (avec login)
- **NGINX** : Page d'accueil + enseigne légale
- **Status API** : Vérification statuts Docker

### Sécurité
- Authentification activée sur Elasticsearch, Kibana, Arkime
- Mots de passe centralisés dans `.env`
- Services accessibles uniquement depuis localhost (sauf enseigne)
- CORS activé sur Elasticsearch

### Accès
- **Page d'accueil** : http://localhost
- **Enseigne légale** : http://localhost/enseigne.html (accessible depuis le réseau)
- **Kibana** : http://localhost:5601 (login: elastic/changeme)
- **Arkime** : http://localhost:8005 (login: admin/admin)
- **Elasticsearch** : http://localhost:9200 (login: elastic/changeme)

## ⚠️ Limitations connues

### Vérifications de statut en temps réel
Les vérifications JavaScript depuis le navigateur sont bloquées par CORS malgré la configuration. 

**Solution** : Les statuts affichés sont statiques. Pour vérifier les vrais statuts :
```bash
docker ps
docker compose ps
```

### Arkime et réseau Docker
Arkime utilise `network_mode: host` pour éviter les problèmes d'IP. Cela signifie qu'il partage le réseau de l'hôte.

## 📝 Commandes utiles

### Démarrer
```bash
cd surveillance-reseau
docker compose up -d
```

### Vérifier les statuts
```bash
docker compose ps
docker logs surveillance-elasticsearch
docker logs surveillance-kibana
docker logs surveillance-arkime
```

### Configurer les mots de passe (première fois)
```bash
# Configurer kibana_system
docker exec surveillance-elasticsearch curl -X POST \
  -u elastic:changeme \
  "http://localhost:9200/_security/user/kibana_system/_password" \
  -H "Content-Type: application/json" \
  -d '{"password":"changeme"}'

# Redémarrer Kibana
docker compose restart kibana
```

### Arrêter
```bash
docker compose down
```

### Voir les logs
```bash
docker compose logs -f
docker compose logs -f suricata
docker compose logs -f elasticsearch
```

## 🎯 Prochaines étapes recommandées

1. **Changer les mots de passe par défaut** (voir CHANGER-MOTS-DE-PASSE.md)
2. **Configurer les dashboards Kibana** pour visualiser les alertes Suricata
3. **Tester la capture** en générant du trafic réseau
4. **Configurer pfSense** (optionnel) pour envoyer ses logs
5. **Simplifier la page d'accueil** en retirant les vérifications de statut JavaScript

## 📚 Documentation

- `CONNEXION.md` : Guide de connexion aux interfaces
- `CHANGER-MOTS-DE-PASSE.md` : Comment changer les mots de passe
- `ARKIME-SETUP.md` : Configuration Arkime
- `SECURITY-SETUP.md` : Configuration de la sécurité
- `docs/` : Documentation complète du projet
