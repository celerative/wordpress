#!/usr/bin/env bash

set -euo pipefail

cd $APP_PATH

sed -i "s/localhost/${WORDPRESS_DB_HOST}/g" wp-config.php
sed -i "s/database_name_here/$WORDPRESS_DB_NAME/g" wp-config.php
sed -i "s/username_here/$WORDPRESS_DB_USER/g" wp-config.php
sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/g" wp-config.php
sed -i "s/wp_/${WORDPRESS_TABLE_PREFIX:-wp_}/g" wp-config.php

echo "Downloading and updating secret key..."

SECRETKEYS=$(curl -sSL https://api.wordpress.org/secret-key/1.1/salt/)
EXISTINGKEYS='put your unique phrase here'
printf '%s\n' "g/$EXISTINGKEYS/d" a "$SECRETKEYS" . w | ed -s wp-config.php

echo "Creating wp-content/uploads"

mkdir -p wp-content/uploads
chown www-data:www-data -R wp-content/uploads

exec "$@"