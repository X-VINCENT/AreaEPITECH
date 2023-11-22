FROM composer:latest as builder

WORKDIR /app

COPY composer.json composer.lock ./

RUN composer install --ignore-platform-reqs --no-scripts

COPY . .

RUN composer install --ignore-platform-reqs
RUN php artisan optimize

FROM php:8.2-fpm as php

WORKDIR /var/www/html

RUN useradd -G www-data,root -u 1000 -d /var/www www

COPY --chown=www-data:www-data --from=builder /app .

RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    libzip-dev \
    git \
    libonig-dev \
    libpq-dev
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-install pdo_pgsql mbstring zip exif pcntl gd
RUN docker-php-ext-configure gd --with-freetype --with-jpeg

RUN php artisan cache:clear
RUN php artisan config:clear

USER www

EXPOSE 9000

CMD ["php-fpm"]
