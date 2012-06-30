#!/bin/sh
# GeoNames allCountries.zip database into MySQL
#features for country with iso code XX
#table structure
#geonameid         : integer id of record in geonames database
#name              : name of geographical point (utf8) varchar(200)
#asciiname         : name of geographical point in plain ascii characters, varchar(200)
#alternatenames    : alternatenames, comma separated varchar(5000)
#latitude          : latitude in decimal degrees (wgs84)
#longitude         : longitude in decimal degrees (wgs84)
#feature class     : see http://www.geonames.org/export/codes.html, char(1)
#feature code      : see http://www.geonames.org/export/codes.html, varchar(10)
#country code      : ISO-3166 2-letter country code, 2 characters
#cc2               : alternate country codes, comma separated, ISO-3166 2-letter country code, 60 characters
#admin1 code       : fipscode (subject to change to iso code), see exceptions below, see file admin1Codes.txt for display names of this code; varchar(20)
#admin2 code       : code for the second administrative division, a county in the US, see file admin2Codes.txt; varchar(80)
#admin3 code       : code for third level administrative division, varchar(20)
#admin4 code       : code for fourth level administrative division, varchar(20)
#population        : bigint (8 byte int)
#elevation         : in meters, integer
#dem               : digital elevation model, srtm3 or gtopo30, average elevation of 3''x3'' (ca 90mx90m) or 30''x30'' (ca 900mx900m) area in meters, integer. srtm processed by cgiar/ciat.
#timezone          : the timezone id (see file timeZone.txt) varchar(40)
#modification date : date of last modification in yyyy-MM-dd format
############
echo "input 2 digits country code in UPPER CASE and press ENTER. For example: UA, US, AO, RU"
echo -n "counry code:"; read cc

database=geonames
table=$cc


cd /tmp
wget http://download.geonames.org/export/dump/$cc.zip
unzip -o $cc.zip

/usr/bin/mysql $@ -e 'CREATE DATABASE IF NOT EXISTS '$database';
	  USE '$database'; CREATE TABLE IF NOT EXISTS '$table' (
	  `geonameid` int(11) NOT NULL AUTO_INCREMENT,
	  `name` varchar(200) DEFAULT NULL,
	  `asciiname` varchar(200) DEFAULT NULL,
	  `alternatenames` varchar(5000) DEFAULT NULL,
	  `latitude` double DEFAULT NULL,
	  `longitude` double DEFAULT NULL,
	  `feature_class` varchar(1) DEFAULT NULL,
	  `feature_code` varchar(10) DEFAULT NULL,
	  `country_code` varchar(2) DEFAULT NULL,
	  `cc2` varchar(2) DEFAULT NULL,
	  `admin1_code` varchar(20) DEFAULT NULL,
	  `admin2_code` varchar(80) DEFAULT NULL,
	  `admin3_code` varchar(20) DEFAULT NULL,
	  `admin4_code` varchar(20) DEFAULT NULL,
	  `population` bigint(8) DEFAULT NULL,
	  `elevation` int(11) DEFAULT NULL,
	  `dem` int(11) DEFAULT NULL,
	  `timezone` varchar(40) DEFAULT NULL,
	  `modification_date` date DEFAULT NULL,
	  PRIMARY KEY (`geonameid`)
	) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;'

/usr/bin/mysql $@ --local-infile=1  -e "USE $database; TRUNCATE $table; LOAD DATA LOCAL INFILE '/tmp/$cc.txt' INTO TABLE $table FIELDS TERMINATED BY \"\t\" LINES TERMINATED BY \"\n\" (geonameid, name, asciiname, alternatenames, latitude, longitude, feature_class, feature_code, country_code, cc2, admin1_code, admin2_code, admin3_code, admin4_code, population, elevation, dem, timezone, modification_date);"

echo "Check $table table in $database database"

