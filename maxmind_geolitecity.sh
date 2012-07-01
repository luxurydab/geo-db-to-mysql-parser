#!/bin/sh
# MaxMind GeoLiteCity CSV into MySQL
############

database=maxmind
table=geolitecity

cd /tmp
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity_CSV/GeoLiteCity_20120605.zip
unzip -o GeoLiteCity_*.zip
cd GeoLiteCity_*
cp GeoLiteCity-Location.csv /tmp/GeoLiteCity.csv -f

/usr/bin/mysql  $@ -e 'CREATE DATABASE IF NOT EXISTS '$database'; USE '$database';
	 CREATE TABLE IF NOT EXISTS `'$table'` (
	  `locId` int(11) NOT NULL AUTO_INCREMENT,
	  `country` varchar(2) DEFAULT NULL,
	  `region` varchar(2) DEFAULT NULL,
	  `city` varchar(255) DEFAULT NULL,
	  `postalCode` int(11) DEFAULT NULL,
	  `latitude` double DEFAULT NULL,
	  `longitude` double DEFAULT NULL,
	  `metroCode` int(11) DEFAULT NULL,
	  `areaCode` int(11) DEFAULT NULL,
	  PRIMARY KEY (`locId`)
	) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;'

/usr/bin/mysql  $@ --local-infile=1 -e "USE $database; TRUNCATE $table; LOAD DATA LOCAL INFILE '/tmp/GeoLiteCity.csv' INTO TABLE $table FIELDS ENCLOSED BY '\"' TERMINATED BY \",\" LINES TERMINATED BY \"\n\"  IGNORE 2 LINES (locId,country,region,city,postalCode,latitude,longitude,metroCode,areaCode);"

echo "Check $table table in $database database"
