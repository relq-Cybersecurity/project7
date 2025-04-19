#!/bin/sh
set -e

echo "🕐 waiting for MariaDB..."
until mysqladmin ping -h"mariadb" --silent; do
    sleep 1
done

cd /var/www/html

# Լցնում ենք փոփոխականները inception/.env ֆայլից
if [ -f /inception/.env ]; then
    export $(grep -v '^#' /inception/.env | xargs)
fi

if [ ! -f wp-config.php ]; then
    echo "⬇️ downloading WordPress..."
    wp core download --allow-root

    echo "⚙️ creating wp-config.php..."
    wp config create --dbname="$MYSQL_DATABASE" --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" --dbhost=mariadb --allow-root

    echo "🚀 installing WordPress..."
    wp core install \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root
else
    echo "✅ WordPress already installed"
fi

# ✅ Թարմացնենք IP URL-ը եթե փոխվել է
echo "🔁 Ensuring WordPress uses correct URL..."
wp option update home "$WP_URL" --allow-root
wp option update siteurl "$WP_URL" --allow-root


if ! grep -q "\$_SERVER\['HTTP_X_FORWARDED_FOR'\]" wp-config.php; then
    echo "🌐 Adding Amazon IP handling to wp-config.php..."
    echo "" >> wp-config.php
    echo "// Allowing real IP behind Amazon reverse proxy" >> wp-config.php
    echo "if (isset(\$_SERVER['HTTP_X_FORWARDED_FOR'])) {" >> wp-config.php
    echo "    \$_SERVER['REMOTE_ADDR'] = \$_SERVER['HTTP_X_FORWARDED_FOR'];" >> wp-config.php
    echo "}" >> wp-config.php
fi

exec "$@"
