#!/bin/bash

echo "starting services ..."

service ssh start
service mysql start
APACHE_RUN_USER=competitor APACHE_RUN_GROUP=competitor apache2-foreground

echo "...done!"