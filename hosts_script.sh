#!/bin/bash
nova --insecure list | awk -F'|' '{print $7 $3}' | sed 's/private-admin-net=//' | sed '/^$/d' | sed '1d'
