ARG DOLIBARR_VERSION="22.0.1"

FROM dolibarr/dolibarr:${DOLIBARR_VERSION}

COPY entrypoint.sh /custom-entrypoint.sh

ENTRYPOINT ["/custom-entrypoint.sh"]

CMD ["apache2-foreground"]
