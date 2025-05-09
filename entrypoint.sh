#!/bin/bash

# Function to parse a URL into its components
parse_url() {
  eval "$(echo "$1" | sed -E \
    -e "s#^(([^:]+)://)?(([^:@]+)(:([^@]+))?@)?([^/?]+)(/(.*))?#\
${PREFIX:-URL_}SCHEME='\2' \
${PREFIX:-URL_}USER='\4' \
${PREFIX:-URL_}PASSWORD='\6' \
${PREFIX:-URL_}HOSTPORT='\7' \
${PREFIX:-URL_}DATABASE='\9'#")"
}

# Parse the DATABASE_URL and extract components
PREFIX="DOLIBARR_DB" parse_url "$DATABASE_URL"

# Separate host and port
DOLI_DB_HOST="$(echo $DOLIBARR_DB_HOSTPORT | sed -E 's,:.*,,')"
DOLI_DB_HOST_PORT="$(echo $DOLIBARR_DB_HOSTPORT | sed -E 's,.*:([0-9]+).*,\1,')"
DOLI_DB_NAME="$DOLIBARR_DB_DATABASE"
DOLI_DB_USER="$DOLIBARR_DB_USER"
DOLI_DB_PASSWORD="$DOLIBARR_DB_PASSWORD"

exec /usr/local/bin/docker-run.sh $@
