#!/bin/bash

echo "Running migrate db pSQL..."
php artisan migrate:refresh
php artisan passport:install
php artisan db:seed
