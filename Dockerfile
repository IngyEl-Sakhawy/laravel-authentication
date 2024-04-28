#Use the official PHP Apache image
FROM php:7.4-apache

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the composer.lock and composer.json files into the container
COPY composer.lock composer.json ./

# Install PHP extensions and dependencies
RUN apt-get update \
    && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev zip unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Composer dependencies
RUN composer install --no-interaction

# Copy the rest of the application code into the container
COPY . .

# Set permissions for Laravel
RUN chown -R www-data:www-data storage bootstrap/cache

# Expose port 80 for Apache
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
