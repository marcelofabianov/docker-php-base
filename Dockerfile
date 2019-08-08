FROM php:7.3-fpm

# Configs
ENV PHP_TIME_ZONE=America/Sao_Paulo \
    PHP_MEMORY_LIMIT=1024M \
    PHP_UPLOAD_MAX_FILESIZE=64M \
    PHP_POST_MAX_SIZE=64M

# PHP Dependências
RUN rm /etc/apt/preferences.d/no-debian-php && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    curl \
    unzip \
    libaio1 \
    libaio-dev \
    libmemcached-dev \
    libz-dev \
    libpq-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libssl-dev \
    libmcrypt-dev \
    libxml2-dev \
    libfbclient2 \
    php-soap \
    zlib1g-dev \
    libzip-dev \
    libicu-dev \
    unixodbc-dev \
    openssl \
    firebird-dev \
    && rm -rf /var/lib/apt/lists/*

# PHP Extensões
RUN docker-php-ext-configure gd --with-jpeg-dir=/usr/lib --with-freetype-dir=/usr/include/freetype2 && \
    pecl install xdebug && \
    docker-php-ext-install \
    gd \
    soap \
    bcmath \
    pcntl \
    intl \
    sockets \
    zip \
    ftp \
    pdo && \
    docker-php-ext-enable \
    xdebug \
    opcache

# Install / Config composer
ENV COMPOSER_HOME /composer
ENV PATH ./vendor/bin:/composer/vendor/bin:$PATH
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

# Config PHP
COPY ./php.ini /usr/local/etc/php/php.ini

# Node.js
RUN curl -sL https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install nodejs -y
RUN npm install npm -g