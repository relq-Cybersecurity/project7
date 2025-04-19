FROM php:8.1-fpm

RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libonig-dev libxml2-dev \
    zip unzip curl less mariadb-client \
    && docker-php-ext-install pdo_mysql mysqli

# Վերբեռնում ենք wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

RUN echo "memory_limit = 256M" > /usr/local/etc/php/conf.d/memlimit.ini

WORKDIR /var/www/html

#COPY entrypoint.sh /entrypoint.sh
#RUN chmod +x /entrypoint.sh

COPY --chown=www-data:www-data entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]
