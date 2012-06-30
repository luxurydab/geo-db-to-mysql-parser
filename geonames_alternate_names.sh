#!/bin/sh
# GeoNames alternateNames.zip database into MySQL
#alternate names with language codes and geonameId
#alternateNameId   : the id of this alternate name, int
#geonameid         : geonameId referring to id in table 'geoname', int
#isolanguage       : iso 639 language code 2- or 3-characters; 4-characters 'post' for postal codes and 'iata','icao' and faac for airport codes, fr_1793 for French Revolution names,  abbr for abbreviation, #link for a website, varchar(7)
#alternate name    : alternate name or name variant, varchar(200)
#isPreferredName   : '1', if this alternate name is an official/preferred name
#isShortName       : '1', if this is a short name like 'California' for 'State of California'
#isColloquial      : '1', if this alternate name is a colloquial or slang term
#isHistoric        : '1', if this alternate name is historic and was used in the past
############

database=geonames
table=alternate_names


cd /tmp
wget http://download.geonames.org/export/dump/alternateNames.zip
unzip -o alternateNames.zip

/usr/bin/mysql $@ -e 'CREATE DATABASE IF NOT EXISTS '$database';
	  USE '$database'; CREATE TABLE IF NOT EXISTS `alternate_names` (
	  `alternateNameId` int(11) NOT NULL AUTO_INCREMENT,
	  `geonameid` int(11) DEFAULT NULL,
	  `isolanguage` varchar(7) DEFAULT NULL,
	  `alternate_name` varchar(200) DEFAULT NULL,
	  `isPreferredName` int(1) DEFAULT NULL,
	  `isShortName` int(1) DEFAULT NULL,
	  `isColloquial` int(1) DEFAULT NULL,
	  `isHistoric` int(1) DEFAULT NULL,
	  PRIMARY KEY (`alternateNameId`)
	) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;'


/usr/bin/mysql $@ --local-infile=1  -e "USE $database; TRUNCATE $table; LOAD DATA LOCAL INFILE '/tmp/alternateNames.txt' INTO TABLE $table FIELDS TERMINATED BY \"\t\" LINES TERMINATED BY \"\n\" (alternateNameId, geonameid, isolanguage, alternate_name, isPreferredName, isShortName, isColloquial, isHistoric);"

echo "Check $table table in $database database"

