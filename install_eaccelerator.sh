#!/bin/bash
echo "Installing git...."
yum  -y install git
echo "Clonning eaccelerator..."
cd /tmp && git clone https://github.com/eaccelerator/eaccelerator.git
echo "installing eaccelerator..."
cd /tmp/eaccelerator && /usr/bin/phpize
./configure
/usr/bin/make
/usr/bin/make install
cp eaccelerator.ini /etc/php.d/
chmod 0777 /tmp/eaccelerator
chown gesio:apache /tmp/eaccelerator
/sbin/service httpd restart
