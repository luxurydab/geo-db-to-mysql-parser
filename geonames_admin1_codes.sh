#!/bin/sh
# GeoNames admin1CodesASCII.txt database into MySQL
#ascii names of admin divisions.
############
database=geonames
table=admin1_codes_ascii

cd /tmp
wget http://download.geonames.org/export/dump/admin1CodesASCII.txt

/usr/bin/mysql $@ -e 'CREATE DATABASE IF NOT EXISTS '$database';
	  USE '$database'; CREATE TABLE IF NOT EXISTS '$table' (
	  `admin_code` varchar(10) DEFAULT NULL,
	  `name` varchar(200) DEFAULT NULL,
	  `asciiname` varchar(200) DEFAULT NULL,	
	  `id` int(11) NOT NULL,
	  PRIMARY KEY (`admin_code`)
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;'

/usr/bin/mysql $@ --local-infile=1 -e "USE $database; TRUNCATE $table; LOAD DATA LOCAL INFILE '/tmp/admin1CodesASCII.txt' INTO TABLE $table FIELDS TERMINATED BY \"\t\" LINES TERMINATED BY \"\n\" (admin_code, name, asciiname, id);"

echo "Check $table table in $database database"
