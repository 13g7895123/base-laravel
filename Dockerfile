FROM php:7.4-apache

# 安装系统依赖
RUN apt-get update && \
    apt-get install -y \
        libzip-dev \
        zip \
        unzip \
        libonig-dev \
        libxml2-dev

# 安装 PHP 扩展
RUN docker-php-ext-install pdo_mysql mysqli mbstring zip exif pcntl bcmath opcache soap

# 设置工作目录
WORKDIR /var/www/html

# 复制应用程序文件到容器中
COPY . .

# 安装 Composer 依赖项
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-scripts

# 设置文件权限
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# 启用 Apache Rewrite 模块
RUN a2enmod rewrite

# 设置 Apache 配置
COPY ./docker/apache2.conf /etc/apache2/apache2.conf

# 设置 PHP 配置
COPY ./docker/php.ini /etc/php/7.4/cli/php.ini

# 暴露端口
EXPOSE 80

