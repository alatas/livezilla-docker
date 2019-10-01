#!/bin/bash
set -o errexit -o nounset -o pipefail

if [ ! "$(ls -A "/var/www/html/ready.html")" ]; then
	echo "initial setup is starting"
	echo "removing older files"
	find . -mindepth 1 ! -regex '^.*_config.*' -delete
	
	echo "extracting setup files"
	unzip /setup/livezilla_server_${livezilla_ver}.zip -o -qq -d /var/www/html/
	
	if [ "$(ls -A "/var/www/html/_config")" ]; then
		echo "config folder saved"
		rm -R "/var/www/html/livezilla/_config"
	fi
	
	mv -f /var/www/html/livezilla/* /var/www/html
	rm -R /var/www/html/livezilla/
	rm /var/www/html/how_to_*.html
	
	mkdir /var/www/html/uploads
	chmod 777 /var/www/html/_config /var/www/html/_language /var/www/html/_log /var/www/html/install var/www/html/stats /var/www/html/uploads

	echo "livezilla is ready!"
	echo "ready" >"/var/www/html/ready.html"
fi

start_system() {
	/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
}

echo "browse http://localhost:8000"
start_system

exit 0
