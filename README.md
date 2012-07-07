# Geo databases to MySql database

A set of bash scripts to parse geo databases into mysql database

 * Automates the updating of geo databases
 * Supports MaxMind, GeoNames
 * Small and simple to customize scripts

## Requirements

 * mysql-server, mysql-client
 * wget
 * unzip, gunzip

## Usage

chmod +x script_name.sh
./script_name.sh mysql options

Example: ./geonames_admin1_codes.sh -uroot -pPASSWORD -h127.0.0.1

Article about geo databases and how to use this set of scripts http://anton.logvinenko.name/en/blog/geo-databases.html

## Scripts description

### Geonames.org ###

geonames_allcountries.sh - all countries combined in one file

geonames_country.sh - features for country with iso code XX, structure similar to all countries file. You will be prompted for country code in script

geonames_cities1000.sh - all cities with a population > 1000 or seats of adm div (ca 80.000)

geonames_cities5000.sh - all cities with a population > 5000 or PPLA (ca 40.000)

geonames_cities15000.sh - all cities with a population > 15000 or capitals (ca 20.000)

geonames_admin1_codes.sh - ascii names of admin divisions

geonames_alternate_names.sh - alternate names with language codes and geonameId

### MaxMind ###

maxmind_geoip_country.sh - IPv4 ranges for countries

maxmind_geoipv6.sh - IPv6 ranges for countries

maxmind_geolitecity.sh - GeoLite City database

maxmind_worldcitiespop.sh - World Cities with Population, Latitude, Longitude

maxmind_region.sh - FIPS 10-4 Subcountry codes
