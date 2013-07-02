#!/bin/sh
# Citieslist into MySQL 
# http://citieslist.ru/
# 
############
database=citieslist
cd /tmp
wget http://citieslist.ru/citieslist-v0.3-3.zip
unzip citieslist-v0.3-3.zip

/usr/bin/mysql $@ -e "CREATE DATABASE IF NOT EXISTS $database;"

/usr/bin/mysql $@ $database < '/tmp/citieslist-v0.3-3/dump.sql'

echo "Check $database database"
