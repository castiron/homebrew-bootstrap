FROM php:7.3-fpm

# Arguments defined in docker-compose.yml
ARG user
ARG uid

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    unzip \
    iputils-ping \
    ruby \
    default-mysql-client \
    rsync \
    imagemagick \
    && docker-php-ext-install zip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Get Composers
COPY --from=composer:2.2.6 /usr/bin/composer /usr/bin/composer

# Tweak PHP configuration
COPY docker/october/php.override.ini $PHP_INI_DIR/conf.d/

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Set working directory
WORKDIR /var/www

ENV LANG C.UTF-8

USER $user
