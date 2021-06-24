FROM craftcms/php-fpm:7.4-dev

USER root

# These are used by our startup scripts
RUN apk add bash jq findutils php7-pecl-xdebug

# Came from https://github.com/urbantrout/craftcms. TODO: determine if this is necessary
RUN apk add gnu-libiconv --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy our scripts into the container and make them +X
COPY scripts/ /scripts/
RUN chown -R www-data:www-data /scripts && chmod -R +x /scripts

WORKDIR /var/www/html
RUN chown -R www-data:www-data .
USER www-data

# Install Craft CMS and save original dependencies in file
RUN composer create-project craftcms/craft . \
    && cp composer.json composer.base

ENTRYPOINT [ "/scripts/run.sh" ]

CMD [ "docker-php-entrypoint", "php-fpm"]
