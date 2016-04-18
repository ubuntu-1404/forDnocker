#/bin/bash

apt-get install squid
sed -i "http_access deny all/c#http_access deny all"            /etc/squid3/squid.conf
sed -i "#http_access deny all/,+0a http_access allow all"       /etc/squid3/squid.conf
service squid3 restart
