ARG DOLIBARR_VERSION="21.0.2"

FROM dolibarr/dolibarr:${DOLIBARR_VERSION}

COPY entrypoint.sh /custom-entrypoint.sh

ENTRYPOINT ["/custom-entrypoint.sh"]

CMD ["apache2-foreground"]
