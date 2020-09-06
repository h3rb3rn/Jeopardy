FROM php:7.4-apache

RUN apt-get update \
 && apt-get install -y \
    git \
    vim \
    sudo \
    default-mysql-client\
    openssh-server \
    iputils-ping \
    iproute2 \
    curl \
    net-tools \
    libssl-dev \
    libicu-dev \
    libxslt-dev \
    zlib1g-dev \
    libzip-dev \
 && a2enmod rewrite \
 && sed -i 's!/var/www/html!/var/www/client!g' /etc/apache2/sites-available/000-default.conf \
 && mv /var/www/html /var/www/public \
 && curl -sS https://getcomposer.org/installer \
  | php -- --install-dir=/usr/local/bin --filename=composer \
 && rm -r /var/lib/apt/lists/*

RUN pecl install xdebug \
 && pecl install zip \
 && docker-php-ext-enable zip \
 && docker-php-ext-enable xdebug \
 && docker-php-ext-install pdo_mysql \
 && docker-php-ext-install xsl \
 && docker-php-ext-configure xsl \
 && docker-php-ext-install -j$(nproc) intl

RUN groupadd dev \
 && useradd -m -g dev --shell /bin/bash dev \
 && echo "dev ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
 && cd /home/dev \
 && mkdir -p ./.ssh \
 && mkdir current \
 && touch .bashrc \
 && echo "alias ll='ls -la --color'" >> .bashrc \
 && usermod -G dev www-data \
 && chmod o+w /opt

WORKDIR /home/dev/current
RUN ln -s /home/dev/current/docker/php/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY startup /usr/local/bin/

CMD ["startup"]

