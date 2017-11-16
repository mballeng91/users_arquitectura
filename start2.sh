./rancher-compose --project-name sa-users-ms \
--url http://192.168.99.100:8080/v1/projects/1a5 \
--access-key 12DD53C770249D7BDB7B \
--secret-key mVqhDv7XRvFKSwCPyrmf3qLaC4WLr59adJj3C87g \
-f docker-compose.yml \
--verbose up \
-d --force-upgrade \
--confirm-upgrade
