#!/bin/sh
# MaxMind FIPS 10-4 Subcountry codes
############
database=maxmind
table=subcountry_codes

cd /tmp
wget http://www.maxmind.com/fips10-4.csv -O regions.csv

/usr/bin/mysql $@ -e 'CREATE DATABASE IF NOT EXISTS '$database'; USE '$database';
	 CREATE TABLE IF NOT EXISTS `'$table'` (
	  `id` int(11) NOT NULL AUTO_INCREMENT,
	  `country` varchar(2) DEFAULT NULL,
	  `region_id` varchar(6) DEFAULT NULL,
	  `region_name` varchar(200) DEFAULT NULL,
	  PRIMARY KEY (`id`)
	) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;'

/usr/bin/mysql $@ --local-infile=1 -e "USE $database; TRUNCATE $table; LOAD DATA LOCAL INFILE '/tmp/regions.csv' INTO TABLE $table FIELDS ENCLOSED BY '\"' TERMINATED BY \",\" LINES TERMINATED BY \"\n\"  (country,region_id,region_name);"


echo "Check $table table in $database database"
