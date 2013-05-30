#!/bin/bash

IGNORE_TABLES=( dataflow_batch_export dataflow_batch_import log_customer log_quote log_summary log_summary_type log_url log_url_info log_visitor log_visitor_info log_visitor_online report_viewed_product_index report_compared_product_index report_event index_event enterprise_logging_event_changes core_cache core_cache_tag enterprise_customer_sales_flat_quote enterprise_customer_sales_flat_quote_address sales_flat_quote sales_flat_quote_address sales_flat_quote_shipping_rate )
CONFIG_FILE="./app/etc/local.xml"
IGNORE_STRING=""
TMP_FILE="./var/.tmp.local.xml"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "$CONFIG_FILE does not exist"
  exit
fi

sed -ne '/default_setup/,/\/default_setup/p' $CONFIG_FILE > $TMP_FILE

function getParam()
{
  RETVAL=$(grep -Eoh "<$1>(<!\[CDATA\[)?(.*)(\]\]>)?<\/$1>" $TMP_FILE | sed "s#<$1><!\[CDATA\[##g;s#\]\]><\/$1>##g")
  if [[ "$2" == "sanitise" ]]; then
    RETVAL=$(echo "$RETVAL" | sed 's/"/\\\"/g')
  fi
echo -e "$RETVAL"
}


DBHOST=$(getParam "host")
DBUSER=$(getParam "username")
DBPASS=$(getParam "password" "sanitise" )
DBNAME=$(getParam "dbname")
TABLE_PREFIX=$(getParam "table_prefix")

[ -f $TMP_FILE ] && rm $TMP_FILE

if [[ "$1" == "--restore" ]] || [[ "$1" == "-r" ]]; then
  echo -n "Are you sure you want to restore ./var/db.sql to $DBNAME? [y/N]: "
  read CONFIRM
  if [[ "$CONFIRM" == "y" ]]; then
    mysql -h$DBHOST -u$DBUSER -p"$DBPASS" $DBNAME < var/db.sql
cat <<EOT
#######################################

 MYSQL IMPORT COMPLETE

########################################
EOT
  fi
  exit
fi

for TABLE in "${IGNORE_TABLES[@]}"; do
  IGNORE_STRING="$IGNORE_STRING --ignore-table=$DBNAME.$TABLE_PREFIX$TABLE"
done

# First dump the structure only
# We use --single-transaction in favour of --lock-tables=false , its slower, but less potential for unreliable dumps
mysqldump -h$DBHOST -u$DBUSER -p"$DBPASS" $DBNAME --no-data --routines --triggers --single-transaction > var/db.sql

# Now dump the data
mysqldump -h$DBHOST -u$DBUSER -p"$DBPASS" $DBNAME $IGNORE_STRING --no-create-db --single-transaction >> var/db.sql

cat <<EOT
#######################################

 MYSQL DUMP COMPLETE

 Backup Location: ./var/db.sql

########################################
EOT

cat <<EOT
########################################

                                (_)
   ___  ___  _ __   __ _ ___ ___ _
  / __|/ _ \| '_ \ / _' / __/ __| |
  \__ \ (_) | | | | (_| \__ \__ \ |
  |___/\___/|_| |_|\__'_|___/___/_|


  Want truly optimised Magento hosting?

  Try http://www.sonassihosting.com ...

#########################################
EOT
