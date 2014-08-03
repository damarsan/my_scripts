grep -iR 'c99' /var/www/vhosts/
grep -iR 'r57' /var/www/vhosts/
find /var/www/vhosts/ -name \*.php -type f -print0 | xargs -0 grep c99
grep -RPn "(passthru|shell_exec|system|base64_decode|fopen|fclose|eval)" /var/www/vhosts/
