#!/bin/sh
# MaxMind World Cities with Population into MySQL
############
database=maxmind
table=worldcitiespop

cd /tmp

wget http://geolite.maxmind.com/download/worldcities/worldcitiespop.txt.gz
gunzip worldcitiespop.txt.gz

/usr/bin/mysql $@ -e 'CREATE DATABASE IF NOT EXISTS '$database'; USE '$database'; CREATE TABLE IF NOT EXISTS `'$table'` (
	  `id` int(11) NOT NULL AUTO_INCREMENT,
	  `Country` varchar(2) DEFAULT NULL,
	  `City` varchar(200) DEFAULT NULL,
	  `AccentCity` varchar(200) DEFAULT NULL,
	  `Region` varchar(2) DEFAULT NULL,
	  `Population` int(11) DEFAULT NULL,
	  `Latitude` double DEFAULT NULL,
	  `Longitude` double DEFAULT NULL,
	  PRIMARY KEY (`id`)
	) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;'

/usr/bin/mysql $@ --local-infile=1  -e "USE $database; TRUNCATE $table; LOAD DATA LOCAL INFILE '/tmp/worldcitiespop.txt' INTO TABLE $table FIELDS TERMINATED BY \",\" LINES TERMINATED BY \"\n\" IGNORE 1 LINES (Country,City,AccentCity,Region,Population,Latitude,Longitude);"

echo "Check $table table in $database database"
