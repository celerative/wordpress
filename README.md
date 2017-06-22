# Wordpress Image
---

This image contains NGINX and PHP 7.1 (FPM) services and, of course, the latest version of wordpress.

The root path is `/var/www/html/public`

## How to use

In order to use this image, you need to follow some conventions:

1. You have to create your Dockerfile and set this image as the base image. Like this:

```Dockerfile
FROM celerative/wordpress

# ...
```

It is needed because we are using `ONBUILD` instructions. You can see that on own `Dockerfile`.
If you have not familiar with `ONBUILD` instruction, check the [ONBUILD Docs](https://docs.docker.com/engine/reference/builder/#onbuild).

2. You need to have the following structure:

```
src/
-- themes/
-- plugins/
Dockerfile
...
```

## Customizing php.ini

You can replace our `php.ini` file.

```Dockerfile
FROM celerative/wordpress

...

COPY uploads.ini /usr/local/etc/php/conf.d/uploads.ini

...
```

