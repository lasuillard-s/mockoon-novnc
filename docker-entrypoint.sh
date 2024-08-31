#!/usr/bin/env bash

NGINX_PATHPORT=${NGINX_PATHPORT:-no}

case $NGINX_PATHPORT in
false | no | n | 0)
	rm -f /app/conf.d/nginx.conf
	;;
esac

exec supervisord -c /app/supervisord.conf
