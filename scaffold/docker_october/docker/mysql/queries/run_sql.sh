#!/bin/sh
mysql -u $MYSQL_USER --password=$MYSQL_PASSWORD -h localhost $MYSQL_DATABASE < /var/lib/queries/$1
