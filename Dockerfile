FROM php:apache

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer
RUN apt-get update -y && apt-get install -y sudo openssl zip unzip zlib1g-dev libpq-dev libicu-dev libzip-dev curl libpng-dev nano git openssh-server && docker-php-ext-install pdo pdo_pgsql pdo_mysql mysqli zip gd exif
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
RUN su - competitor -c "composer global require laravel/installer"
RUN ln -s /var/www/.config/composer/vendor/bin/laravel /usr/local/bin/laravel
#RUN laravel new demo

####### INSTALL ANGULAR CLI #######
RUN npm install -g @angular/cli

####### INSTALL VUE CLI #######
RUN npm install -g @vue/cli

####### BEGIN STARTUP #######
WORKDIR /var/www/

ADD ./entrypoint.sh /root/entrypoint.sh
RUN chown root.root /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]
