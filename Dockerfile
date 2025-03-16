FROM php:8.2-fpm

# 作業ディレクトリ
WORKDIR /var/www/html

# パッケージインストール
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# PHP拡張機能インストール
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Composerインストール
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# ユーザー作成
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# 権限設定
COPY . /var/www/html
RUN chown -R www:www /var/www/html

# ユーザー切り替え
USER www

# 起動
CMD ["php-fpm"]

EXPOSE 9000
