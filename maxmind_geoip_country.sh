#!/bin/sh
# MaxMind GeoIP Free Country CSV into MySQL
############
database=maxmind
table=geoipcountry

cd /tmp
wget http://geolite.maxmind.com/download/geoip/database/GeoIPCountryCSV.zip
unzip -o GeoIPCountryCSV.zip

/usr/bin/mysql  $@ -e 'CREATE DATABASE IF NOT EXISTS '$database'; USE '$database';
	 CREATE TABLE IF NOT EXISTS `'$table'` (
	  `start_address` varchar(15) DEFAULT NULL,
	  `end_address` varchar(15) DEFAULT NULL,
	  `start_number` int(11) DEFAULT NULL,
	  `end_number` int(11) DEFAULT NULL,
	  `country_code` varchar(2) DEFAULT NULL,
	  `country_name` varchar(50) DEFAULT NULL
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;'

/usr/bin/mysql  $@ --local-infile=1 -e "USE $database; TRUNCATE $table; LOAD DATA LOCAL INFILE '/tmp/GeoIPCountryWhois.csv' INTO TABLE $table FIELDS ENCLOSED BY '\"' TERMINATED BY \",\" LINES TERMINATED BY \"\n\" (start_address,end_address,start_number,end_number,country_code,country_name);"

echo "Check $table table in $database database"
