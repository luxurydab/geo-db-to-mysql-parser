#!/bin/sh
# Yahoo GeoPlanet database into MySQL
# 
############
database=yahoo_geoplanet

cd /tmp
wget http://ydn.zenfs.com/site/geo/geoplanet_data_7.9.0.zip
unzip geoplanet_data_7.9.0.zip
/usr/bin/mysql $@ -e 'CREATE DATABASE IF NOT EXISTS '$database';'

/usr/bin/mysql $@ -e 'USE '$database'; 
CREATE TABLE IF NOT EXISTS places (
  `woeid` varchar(15) NOT NULL,
  `iso` varchar(6) NOT NULL,
  `name` text NOT NULL,
  `language` varchar(6) NOT NULL,
  `type` varchar(15) NOT NULL,
  `parent` varchar(15) NOT NULL,
  PRIMARY KEY (`woeid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8; 
CREATE TABLE IF NOT EXISTS  aliases (
  `woeid` varchar(15) NOT NULL,
  `name` text NOT NULL,
  `name_type` varchar(6) NOT NULL,
  `language` varchar(6) DEFAULT NULL,
  KEY `woeid` (`woeid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS  adjacencies (
  `place_woeid` varchar(15) NOT NULL,
  `place_iso` varchar(6) NOT NULL,
  `neighbour_woeid` varchar(15) NOT NULL,
  `neighbour_iso` varchar(6) NOT NULL,
  KEY `place_woeid` (`place_woeid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS  admins (
  `woeid` varchar(15) NOT NULL,
  `iso` varchar(6) NOT NULL,
  `state` varchar(200) NOT NULL,
  `county` varchar(200) NOT NULL,
  `local_admin` varchar(200) DEFAULT NULL,
  `country` varchar(200) DEFAULT NULL,
  `continent` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`woeid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;'


/usr/bin/mysql $@ --local-infile=1 -e "USE $database; TRUNCATE places; LOAD DATA LOCAL INFILE '/tmp/geoplanet_places_7.9.0.tsv' INTO TABLE places FIELDS ENCLOSED BY '\"' TERMINATED BY \"\t\" LINES TERMINATED BY \"\n\" IGNORE 1 LINES (woeid,iso,name,language,type,parent);"

/usr/bin/mysql $@ --local-infile=1 -e "USE $database; TRUNCATE aliases; LOAD DATA LOCAL INFILE '/tmp/geoplanet_aliases_7.9.0.tsv' INTO TABLE aliases FIELDS ENCLOSED BY '\"' TERMINATED BY \"\t\" LINES TERMINATED BY \"\n\" IGNORE 1 LINES (woeid,name,name_type,language);"

/usr/bin/mysql $@ --local-infile=1 -e "USE $database; TRUNCATE adjacencies; LOAD DATA LOCAL INFILE '/tmp/geoplanet_adjacencies_7.9.0.tsv' INTO TABLE adjacencies FIELDS ENCLOSED BY '\"' TERMINATED BY \"\t\" LINES TERMINATED BY \"\n\" IGNORE 1 LINES (place_woeid,place_iso,neighbour_woeid,neighbour_iso);"


/usr/bin/mysql $@ --local-infile=1 -e "USE $database; TRUNCATE admins; LOAD DATA LOCAL INFILE '/tmp/geoplanet_admins_7.9.0.tsv' INTO TABLE admins FIELDS ENCLOSED BY '\"' TERMINATED BY \"\t\" LINES TERMINATED BY \"\n\" IGNORE 1 LINES (woeid,iso,state,county,local_admin,country,continent);"

echo "Check $database database" 
