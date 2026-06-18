#!/usr/bin/env bash

NGINX_PATHPORT="${NGINX_PATHPORT:-no}"

case "$NGINX_PATHPORT" in
false | no | n | 0)
  rm --force /app/conf.d/nginx.conf
  ;;
esac

exec supervisord --configuration /app/supervisord.conf
