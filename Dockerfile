FROM php:7.3-fpm

# Timezone
ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# PHP Dependências
RUN rm /etc/apt/preferences.d/no-debian-php && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    autoconf \
    autogen \
    apt-utils \
    build-essential \
    unzip \
    software-properties-common \
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

# Install / Deployer
RUN curl -LO https://deployer.org/deployer.phar
RUN mv deployer.phar /usr/local/bin/dep
RUN chmod +x /usr/local/bin/dep

# Config PHP
COPY ./php.ini /usr/local/etc/php/php.ini