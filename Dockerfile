# Railway Deployment - Build from Server Dockerfile
FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpq-dev \
    && docker-php-ext-install pdo pdo_mysql \
    && a2enmod rewrite \
    && a2enmod php8.2 \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www/html

# Copy server files
COPY Server/c2-server /var/www/html/c2-server
COPY Server/web-socket /var/www/html/web-socket
COPY Server/docker /var/www/html/docker

# Set permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Install PHP dependencies for c2-server
WORKDIR /var/www/html/c2-server
RUN composer install --no-dev --optimize-autoloader

# Install PHP dependencies for web-socket
WORKDIR /var/www/html/web-socket
RUN composer install --no-dev --optimize-autoloader

# Increase PHP file upload limits
RUN echo "upload_max_filesize = 128M" >> /usr/local/etc/php/conf.d/uploads.ini && \
    echo "post_max_size = 129M" >> /usr/local/etc/php/conf.d/uploads.ini

# Copy Apache configuration
COPY Server/docker/apache-default.conf /etc/apache2/sites-available/000-default.conf
COPY Server/docker/apache-conf.conf /etc/apache2/conf-available/custom.conf

RUN a2enconf custom

# Expose ports
EXPOSE 80
EXPOSE 8080

# Set working directory back
WORKDIR /var/www/html

# Start Apache
CMD ["apache2ctl", "-D", "FOREGROUND"]
