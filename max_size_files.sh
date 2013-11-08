#!/bin/bash
find /var/www -type f -size +300M 2>/dev/null | xargs du 2>/dev/null | sort -n | tail -n 10 | cut -f 2 | xargs -n 1 du -h
read -p "Do you want to delete logs files(y/n)? " REPLY
[ "$REPLY" == "n" ] && echo "Good Bye!"
[ "$REPLY" == "y" ] && read -p "Provide the full exact path of Apache log file to purge:(apache will be restarted) " full_path; echo > $full_path; /sbin/service httpd restart;
