#!/bin/bash

apt update

apt install -y apache2  sudo openssl zip unzip zlib1g-dev libpq-dev libicu-dev libzip-dev curl libpng-dev nano git openssh-server mariadb-server curl software-properties-common
apt install -y php php-mbstring php-xml

# INSTALL NODE
curl -sL https://deb.nodesource.com/setup_16.x | bash - 
apt install -y nodejs

# INSTALL COMPOSER
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# if you already have a user created skip this line
# sorry for the hack ... i am sure that there is a better way ;-)
# password is "competitor"
useradd -d /var/www/ -U -s /bin/bash -p "\$6\$EF/5kOaPWb3oGgDH\$e9PQyrFx47ZqpH4WUsf0TKHFhTWtr5XtxWLJ1NrmTA3f4Up/BhxM5gqeuadtkM/yaE0scxqIYBmlpnPXqismZ1" competitor
usermod -aG sudo competitor


# adapt apache config 
echo "IncludeOptional /var/www/vhost.conf" >> /etc/apache2/apache2.conf
rm /etc/apache2/sites-enabled/*.conf
cat <<EOT >> /var/www/vhost.conf
<VirtualHost *:80>
	ServerAdmin webmaster@localhost
	DocumentRoot /var/www/html
	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOT

####### INSTALL LARAVEL #######
su - competitor -c "composer global require laravel/installer"
ln -s /var/www/.config/composer/vendor/bin/laravel /usr/local/bin/laravel
laravel new laravel

####### INSTALL ANGULAR CLI #######
npm install -g @angular/cli
ng new angular

####### INSTALL VUE CLI #######
npm install -g @vue/cli

npm install -g mocha
npm install -g cypress

rm -rf /var/www/html
chown -R competitor.competitor /var/www