#!/bin/bash

get_dns_spf1() { 
   dig +short txt "$1" | 
   tr ' ' '\n' |
   while read entry; do 
      case "$entry" in 
         ip4:*)  echo ${entry#*:} ;; 
         include:*) get_dns_spf1 ${entry#*:} ;;
      esac
   done |
   sort -u
}

check_spf() {
	for i in "${@:2}"; do [[ "$i" == "$1" ]]  && echo "ok"; done
}
database="gesio_freemium"
echo "#############################"
echo "Checking mail requeriments..."
echo "#############################"
echo "Checking  ENVIO FACTURAS Y RECLAMACIONES DE RECIBOS mailfrom:"
mailfrom_f=`psql -U postgres -d ${database} -c "SELECT mailadm FROM configuracion;" | head -3 | tail -1`
echo -e "\e[32m$mailfrom_f\e[0m"
echo "Checking  ENVIO PRESUPUESTOS mailfrom:"
temp=`psql -U postgres -d ${database} -c "SELECT graf_senderdeluser_presupuestos FROM confgrafica;" | head -3 | tail -1`
if [ "$temp" == "1" ]; then 
	mailfrom_p=`psql -U postgres -d ${database} -c "SELECT tra_mail FROM trabajador;" | head -3 | tail -1`
else 
	mailfrom_p=`psql -U postgres -d ${database} -c "SELECT graf_alertassenderadm FROM confgrafica;" | head -3 | tail -1`
fi
echo -e "\e[32m$mailfrom_p\e[0m"
echo "Checking  ENVIO DE ALERTAS mailfrom:"
mailfrom_al=`psql -U postgres -d ${database} -c "SELECT graf_alertasfrommail FROM confgrafica;" | head -3 | tail -1`
echo -e "\e[32m$mailfrom_al\e[0m"
echo "Checking  ENVIO DE AVISOS mailfrom:"
mailfrom_av=`psql -U postgres -d ${database} -c "SELECT graf_avisosfrommail FROM confgrafica;" | head -3 | tail -1`
echo -e "\e[32m$mailfrom_av\e[0m"
echo "##############################"
echo "Checking server requeriments..."
echo "#############################"
echo "public server ip:"
public_ip=`curl -s icanhazip.com`
echo -e "\e[34m$public_ip\e[0m"
host_name=`curl -s myhostname.net | grep Hostname | awk -F: '{print $2}'`
echo "Public Hostname:"
if [ "$host_name" == "   (none)" ] 
then
	echo -e "\e[31mPublic Hostname Not Found!\e[0m"
else 
	echo -e "\e[34m$host_name\e[0m"
fi
echo "reverse DNS:"
rdns=`host ${public_ip}`
rdns_f=`echo ${rdns} | grep "not found"`
echo -e "\e[34m$rdns\e[0m"

if [ -n "$rdns_f" ]
then
echo -e "\e[31mReverse DNS Not Found!\e[0m"
fi

echo "##############################"
echo "Checking domain requeriments..."
echo "#############################"
echo "domains found:"
dom_1=`echo ${mailfrom_f} | awk -F'@' '{print $2}'`
dom_2=`echo ${mailfrom_p} | awk -F'@' '{print $2}'`
dom_3=`echo ${mailfrom_al} | awk -F'@' '{print $2}'`
dom_4=`echo ${mailfrom_av} | awk -F'@' '{print $2}'`

if [ "$dom_1" == "$dom_2" ]; 
	then dom_2="" 
fi
if [ "$dom_1" == "$dom_3" ]; 
	then dom_3="" 
fi
if [ "$dom_1" == "$dom_4" ]; 
	then dom_4="" 
fi
if [ "$dom_2" == "$dom_3" ]; 
	then dom_3="" 
fi
if [ "$dom_2" == "$dom_4" ]; 
	then dom_4="" 
fi
if [ "$dom_3" == "$dom_4" ]; 
	then dom_4="" 
fi


if [ "$dom_1" != "" ]; then
	echo -e "\e[35m$dom_1\e[0m"
	echo  "ips in SPF records:"
	ips=(`get_dns_spf1 ${dom_1}`)
	echo ${ips[*]}
echo "###############"
res=$(check_spf "$public_ip" ${ips[@]})
	if [ "$res" == "ok" ] 
		then 
			echo -e "\e[32m$public_ip found in $dom_1 SPF Record\e[0m"
		else  
			echo -e "\e[31m$public_ip not found in $dom_1 SPF Record\e[0m"
	fi
fi



if [ "$dom_2" != "" ]; then
	echo -e "\e[35m$dom_2\e[0m"
	echo  "ips in SPF records:"
	ips=(`get_dns_spf1 ${dom_2}`)
	echo ${ips[*]}
echo "###############"
res=$(check_spf "$public_ip" ${ips[@]})
	if [ "$res" == "ok" ] 
		then 
			echo -e "\e[32m$public_ip found in $dom_2 SPF Record\e[0m"
		else  
			echo -e "\e[31m$public_ip not found in $dom_2 SPF Record\e[0m"
	fi
fi


if [ "$dom_3" != "" ]; then
	echo -e "\e[35m$dom_3\e[0m"
	echo  "ips in SPF records:"
	ips=(`get_dns_spf1 ${dom_3}`)
	echo ${ips[*]}
echo "###############"
res=$(check_spf "$public_ip" ${ips[@]})
	if [ "$res" == "ok" ] 
		then 
			echo -e "\e[32m$public_ip found in $dom_3 SPF Record\e[0m"
		else  
			echo -e "\e[31m$public_ip not found in $dom_3 SPF Record\e[0m"
	fi
fi

if [ "$dom_4" != "" ]; then
	echo -e "\e[35m$dom_4\e[0m"
	ips=(`get_dns_spf1 ${dom_4}`)
	echo  "ips in SPF records:"
	echo ${ips[*]}
echo "###############"
res=$(check_spf "$public_ip" ${ips[@]})
	if [ "$res" == "ok" ] 
		then 
			echo -e "\e[32m$public_ip found in $dom_4 SPF Record\e[0m"
		else  
			echo -e "\e[31m$public_ip not found in $dom_4 SPF Record\e[0m"
	fi
fi
