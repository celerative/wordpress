FROM celerative/nginx-php-fpm:7.1

MAINTAINER Celerative <bruno.cascio@celerative.com>

ENV WORDPRESS_VERSION latest
ENV APP_PATH /var/www/html/public

WORKDIR $APP_PATH

#
# Install SO deps
#
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ed \
  && rm -rf /var/lib/apt/lists/*

#
# Install PHP deps
#
RUN docker-php-ext-install mysqli

#
# Pull wordpress
#
RUN curl -o wordpress.tar.gz -fSL "https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz" \
  && tar -xzf wordpress.tar.gz --strip-components 1 \
  # Remove wordpress zip
  && rm wordpress.tar.gz \
  # Set user and server permissions
  && chown -R www-data:www-data $APP_PATH/ \
  # Set wp-config.php file available
  && mv wp-config-sample.php wp-config.php

# Copy default php configuration
COPY uploads.ini /usr/local/etc/php/conf.d/uploads.ini

# Project files. Those files should be into the src/ folder
ONBUILD COPY ./src/themes $APP_PATH/wp-content/themes
ONBUILD COPY ./src/plugins $APP_PATH/wp-content/plugins

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["/usr/bin/supervisord"]
