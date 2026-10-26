FROM php:8.3-apache-bookworm
RUN docker-php-ext-install pdo pdo_mysql \
 && a2enmod rewrite headers \
 && sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf \
 && sed -i 's/:80>/:8080>/' /etc/apache2/sites-available/000-default.conf \
 && printf '\nServerName localhost\n' >> /etc/apache2/apache2.conf \
 && chown -R www-data:www-data /var/www/html
COPY --chown=www-data:www-data . /var/www/html/
USER www-data
EXPOSE 8080
