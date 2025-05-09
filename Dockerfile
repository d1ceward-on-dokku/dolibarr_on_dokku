ARG DOLIBARR_VERSION="20.0.3"

FROM dolibarr/dolibarr:${DOLIBARR_VERSION}

COPY entrypoint.sh /custom-entrypoint.sh

ENTRYPOINT ["/custom-entrypoint.sh"]

CMD ["apache2-foreground"]
