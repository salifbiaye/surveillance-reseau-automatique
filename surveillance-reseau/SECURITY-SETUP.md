# Configuration de la sécurité

## Activation de l'authentification

L'authentification est maintenant activée sur tous les services :

### Identifiants par défaut

**Kibana** (http://localhost:5601)
- Username: `elastic`
- Password: `changeme`

**Arkime** (http://localhost:8005)
- Username: `admin`
- Password: `admin`

**Elasticsearch API** (http://localhost:9200)
- Username: `elastic`
- Password: `changeme`

## Première configuration

1. **Démarrer les services**
```bash
cd surveillance-reseau
docker-compose up -d
```

2. **Configurer le mot de passe kibana_system**
```bash
docker exec surveillance-elasticsearch curl -X POST -u elastic:changeme \
  "http://localhost:9200/_security/user/kibana_system/_password" \
  -H "Content-Type: application/json" \
  -d '{"password":"changeme"}'
```

3. **Redémarrer Kibana**
```bash
docker-compose restart kibana
```

4. **Accéder à Kibana**
- Ouvrir http://localhost:5601
- Une page de login apparaît automatiquement
- Se connecter avec `elastic` / `changeme`

## Changer les mots de passe (RECOMMANDÉ)

### Elasticsearch
```bash
docker exec surveillance-elasticsearch curl -X POST -u elastic:changeme \
  "http://localhost:9200/_security/user/elastic/_password" \
  -H "Content-Type: application/json" \
  -d '{"password":"VotreNouveauMotDePasse"}'
```

Puis mettre à jour dans :
- `docker-compose.yml` : `ELASTIC_PASSWORD`
- `configs/filebeat/filebeat.yml` : `password`
- `configs/arkime/config.ini` : `elasticsearch` URL

### Arkime
```bash
docker exec surveillance-arkime /opt/arkime/bin/arkime_add_user.sh admin "Admin User" VotreNouveauMotDePasse --admin
```

## Désactiver l'authentification (si besoin)

Si tu veux revenir en mode sans authentification :

1. Dans `docker-compose.yml`, service `elasticsearch`:
```yaml
- xpack.security.enabled=false
```

2. Supprimer les lignes d'authentification dans `kibana`:
```yaml
# Supprimer ces lignes:
- ELASTICSEARCH_USERNAME=kibana_system
- ELASTICSEARCH_PASSWORD=changeme
- XPACK_SECURITY_ENABLED=true
```

3. Dans `configs/filebeat/filebeat.yml`:
```yaml
# Supprimer username et password
output.elasticsearch:
  hosts: ["elasticsearch:9200"]
```

4. Dans `configs/arkime/config.ini`:
```ini
elasticsearch=http://elasticsearch:9200
```

## Pourquoi l'authentification ?

- Protège l'accès aux données sensibles
- Empêche les modifications non autorisées
- Conforme aux bonnes pratiques de sécurité
- Requis pour les environnements de production
