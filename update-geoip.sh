#!/bin/bash

# GeoIP Update for Piwik
# Script to automatically pull down the latest GeoIP city database and move it
# into place for Piwik analytics to use


# Maxmind publishes a GeoIP City database for greater accuracy
# http://dev.maxmind.com/geoip/legacy/geolite/

# It gets "updated on the first Tuesday of each month", so this
# script will pull it down and properly rename it for Piwik to use.

# After that, this script need only be run on a monthly cron. Example:
# 25 2 9 * * /bin/sh /path/to/piwik/misc/update-geoip.sh

# For more info, see Piwik's docs here:
# http://piwik.org/faq/how-to/#faq_164


#    Copyright (C) 2014  Jacob "BoomShadow" Tirey, of PeachFlame
#    Written for 3trav.com

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


# This is the only variable that the user needs to set; it's the path to your Piwik installation folder:
PATH_TO_PIWIK="/var/www/piwik"


# You /shouldn't/ need to modify any below. Just implement the monthly cron job.
echo "Beginning script run:"
echo "---------------------"
cd $PATH_TO_PIWIK/misc
if [ $? -eq 0 ]; then
  echo "Successfully changed to Piwik directory."
else
  echo "Problem changing to Piwik directory... exiting!"
  exit 1
fi

rm -rf GeoIPCity.dat
if [ $? -eq 0 ]; then
  echo "Successfully removed old GeoIP database file."
else
  echo "Problem removing old GeoIP database file... exiting!"
  exit 1
fi

echo "---------------------"
echo "Downloading new GeoIP database file:"

wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
if [ $? -eq 0 ]; then
  echo "Successfully downloaded new GeoIP database file."
else
  echo "Problem downloading new GeoIP database file... exiting!"
  exit 1
fi

echo "---------------------"
echo "Unpacking the new GeoIP database file:"

/usr/bin/gunzip GeoLiteCity.dat.gz
if [ $? -eq 0 ]; then
  echo "Successfully unpacked new GeoIP database file."
else
  echo "Problem unpacking new GeoIP database file... exiting!"
  exit 1
fi

echo "---------------------"
echo "And finally, renaming the database so Piwik can use it:"

mv GeoLiteCity.dat GeoIPCity.dat
if [ $? -eq 0 ]; then
  echo "Successfully renamed new GeoIP database file."
else
  echo "Problem renaming new GeoIP database file... exiting!"
  exit 1
fi

echo "---------------------"
echo "Done!"