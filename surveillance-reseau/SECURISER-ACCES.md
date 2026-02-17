# Configurer le mot de passe de kibana_system
docker exec surveillance-elasticsearch curl -X POST \
  -u elastic:changeme \
  "http://localhost:9200/_security/user/kibana_system/_password" \
  -H "Content-Type: application/json" \
  -d '{"password":"changeme"}'

# Redémarrer Kibana
docker-compose restart kibana
