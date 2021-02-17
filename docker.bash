#!/bin/bash

export $(egrep -v '^#' .env | xargs)

case $1 in
  start)
    docker run --rm \
    -p 127.0.0.1:$REGISTRY_PORT:443 \
    --name registry \
    -v $(pwd)/storage:/var/lib/registry \
    -v "$(pwd)"/auth:/auth \
    -e REGISTRY_LOG_LEVEL=debug \
    -e "REGISTRY_AUTH=htpasswd" \
    -e "REGISTRY_HTTP_SECRET='$REGISTRY_HTTP_SECRET'" \
    -e "REGISTRY_AUTH_HTPASSWD_REALM='Registry Realm'" \
    -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
    -e REGISTRY_HTTP_ADDR=0.0.0.0:443 \
    -v "$(pwd)"/certs:/certs \
    -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/docker.crt \
    -e REGISTRY_HTTP_TLS_KEY=/certs/docker.key \
    registry:2
  ;;

  stop)
    docker kill registry || true
  ;;

  update-certs)
    cp /etc/letsencrypt/live/$REGISTRY_SSL_FOLDER/fullchain.pem certs/docker.crt
    cp /etc/letsencrypt/live/$REGISTRY_SSL_FOLDER/privkey.pem certs/docker.key
  ;;

  update-password)
    read -p "Registry user: " USERNAME
    read -s -p "New password: " PASSWORD

    docker run --rm -it appsoa/docker-alpine-htpasswd "$USERNAME" "$PASSWORD" > auth/htpasswd
  ;;

  install)
    rm /usr/local/bin/docker-registry
    ln -s $(pwd)/docker.bash /usr/local/bin/docker-registry
    chmod +x /usr/local/bin/docker-registry
    cp docker-registry.service /etc/systemd/system/docker-registry.service
    echo 'WorkingDirectory='$PWD >> /etc/systemd/system/docker-registry.service
  ;;

  *)
    echo Usage:
    echo "  bash docker.bask <start | stop | update-certs | update-password | install>"
  ;;
esac
