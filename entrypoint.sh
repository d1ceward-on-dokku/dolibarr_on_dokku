#!/bin/bash
set -e

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
PREFIX="DOLIBARR_DB_" parse_url "$DATABASE_URL"

# Separate host and port
DOLIBARR_DB_HOST="$(echo $DOLIBARR_DB_HOSTPORT | sed -E 's,:.*,,')"
DOLIBARR_DB_PORT="$(echo $DOLIBARR_DB_HOSTPORT | sed -E 's,.*:([0-9]+).*,\1,')"

# Export database environment variables
export DOLI_DB_TYPE="mysqli"
export DOLI_DB_HOST="$DOLIBARR_DB_HOST"
export DOLI_DB_HOST_PORT="$DOLIBARR_DB_PORT"
export DOLI_DB_NAME="$DOLIBARR_DB_DATABASE"
export DOLI_DB_USER="$DOLIBARR_DB_USER"
export DOLI_DB_PASSWORD="$DOLIBARR_DB_PASSWORD"

exec /usr/local/bin/docker-run.sh $@
