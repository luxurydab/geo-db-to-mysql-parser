#!/bin/sh
# MaxMind GeoIP IPv6 CSV into MySQL
############
database=maxmind
table=geoipv6

cd /tmp
wget http://geolite.maxmind.com/download/geoip/database/GeoIPv6.csv.gz
gunzip GeoIPv6.csv.gz

/usr/bin/mysql  $@ -e 'CREATE DATABASE IF NOT EXISTS '$database'; USE '$database';
	 CREATE TABLE IF NOT EXISTS `'$table'` (
	  `short_address` varchar(10) DEFAULT NULL,
	  `full_address` varchar(40) DEFAULT NULL,
	  `start_number` bigint(11) DEFAULT NULL,
	  `end_number` bigint(11) DEFAULT NULL,
	  `country_code` varchar(2) DEFAULT NULL,
	  `country_name` varchar(50) DEFAULT NULL
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;'

/usr/bin/mysql  $@ --local-infile=1 -e "USE $database; TRUNCATE $table; LOAD DATA LOCAL INFILE '/tmp/GeoIPv6.csv' INTO TABLE $table FIELDS ENCLOSED BY '\"' TERMINATED BY \", \" LINES TERMINATED BY \"\n\" (short_address,full_address,start_number,end_number,country_code,country_name);"


echo "Check $table table in $database database"
