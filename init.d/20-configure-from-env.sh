#!/bin/bash

set -e

envsubst \$NGINX_LISTEN_PORT, < /config/nginx.conf > /etc/nginx/sites-enabled/seafile.conf
