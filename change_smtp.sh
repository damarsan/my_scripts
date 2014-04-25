#!/bin/bash
if [ -e /etc/postfix/main.cf.bkp ]
        then
                cp /etc/postfix/main.cf.bkp /etc/postfix/main.cf
        else
                cp /etc/postfix/main.cf /etc/postfix/main.cf.bkp
fi
pos1=$(/bin/awk -F"|#|" ' {print $1} ' ./smtpgesconf.txt | sed "s/|//g")
if [ $pos1 == "1" ]
	then 
		pos2=$(/bin/awk -F"|#|" ' {print $2} ' ./smtpgesconf.txt | sed "s/|//g")
		pos3=$(/bin/awk -F"|#|" ' {print $3} ' ./smtpgesconf.txt | sed "s/|//g")
		pos4=$(/bin/awk -F"|#|" ' {print $4} ' ./smtpgesconf.txt | sed "s/|//g")
		pos5=$(/bin/awk -F"|#|" ' {print $5} ' ./smtpgesconf.txt | sed "s/|//g")
		smtp=$(echo $pos2 | base64 -di)
		user=$(echo $pos3 | base64 -di)
		passwd=$(echo $pos4 | base64 -di)
		port=$(echo $pos5 | base64 -di)
		echo [$smtp]:$port $user:$passwd > /etc/postfix/sasl_passwd
		chmod 600 /etc/postfix/sasl_passwd
		postmap /etc/postfix/sasl_passwd
		echo "################### SMTP RELAY CONFIG###########" >> /etc/postfix/main.cf
		echo "relayhost = [$smtp]:$port" >> /etc/postfix/main.cf
		echo "smtp_sasl_auth_enable = yes" >> /etc/postfix/main.cf
		echo "smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd" >> /etc/postfix/main.cf
		echo "smtp_sasl_security_options = noanonymous" >> /etc/postfix/main.cf
		echo "smtp_tls_CAfile = /etc/pki/tls/certs/ca-bundle.crt" >> /etc/postfix/main.cf
		echo "smtp_use_tls = yes" >> /etc/postfix/main.cf
fi
/etc/init.d/postfix restart
