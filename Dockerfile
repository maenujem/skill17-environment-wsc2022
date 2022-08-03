FROM php:8.0-apache

#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer --version=1.10.23
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer --version=2.1.9
RUN apt-get update -y && apt-get install -y sudo openssl zip unzip zlib1g-dev libpq-dev libicu-dev libzip-dev libpng-dev curl nano git openssh-server
RUN docker-php-ext-install pdo pdo_pgsql pdo_mysql mysqli zip gd exif
RUN a2enmod rewrite
RUN echo "IncludeOptional /var/www/vhost.conf" >> /etc/apache2/apache2.conf
RUN rm /etc/apache2/sites-enabled/*.conf
ADD ./vhost.conf /var/www/vhost.conf

# RUN echo "max_execution_time = 1200" > /usr/local/etc/php/conf.d/execution.ini
# RUN echo "memory_limit = 2048M" >> /usr/local/etc/php/conf.d/execution.ini
# RUN echo "post_max_size = 100M" >> /usr/local/etc/php/conf.d/execution.ini
# RUN echo "upload_max_filesize = 100M" >> /usr/local/etc/php/conf.d/execution.ini

####### CREATE USER #######
# sorry for the hack ... i am sure that there is a better way ;-)
# password is "competitor"
RUN useradd -d /var/www/ -U -s /bin/bash -p "\$6\$EF/5kOaPWb3oGgDH\$e9PQyrFx47ZqpH4WUsf0TKHFhTWtr5XtxWLJ1NrmTA3f4Up/BhxM5gqeuadtkM/yaE0scxqIYBmlpnPXqismZ1" competitor
RUN chown -R competitor.competitor /var/www
RUN usermod -aG sudo competitor

####### BEGIN MARIADB #######
RUN apt-get install -y mariadb-server

####### INSTALL NODE #######
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs


####### INSTALL LARAVEL #######
RUN su - competitor -c "composer global require -W laravel/framework:8.63.0" && \
su - competitor -c "composer global require laravel/laravel:8.6.3" && \
su - competitor -c "composer global require laravel/installer:4.2.8" && \
ln -s /var/www/.config/composer/vendor/bin/laravel /usr/local/bin/laravel
#RUN laravel new demo

####### INSTALL ANGULAR CLI #######
RUN npm install -g @angular/cli@12.2.9

####### INSTALL VUE CLI #######
RUN npm install -g vue@3.2.20 && \
npm install -g @vue/cli@4.5.14

####### INSTALL UNITTESTING #######
RUN su - competitor -c "composer global require -W phpunit/phpunit:9.5.10"
RUN npm install -g testcafe@1.18.0 && \
npm install --save-dev cypress@9.5.0


####### BEGIN STARTUP #######
WORKDIR /var/www/

ADD ./entrypoint.sh /root/entrypoint.sh
RUN chown root.root /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]

## TODO: phpMyAdmin?
## TODO: let competitor/root create databases via 127.0.0.1 (ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password)
