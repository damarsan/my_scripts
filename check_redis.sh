#!/bin/bash
memory = $(/usr/bin/redis-cli -i 1 info | grep used_memory_human | awk -F: '{print $2}')
echo $memory
