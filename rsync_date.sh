d -p "Indica el número de días que los archivos fueron modificados: " dias
dest=""
ruta1=""
ruta2=""

if [ -f last_modified ];
        then
        rm -f last_modified
fi
find $ruta1 -ctime -$dias -type f -printf '%f\n' > last_modified
rsync $ruta1 -v -avz --stats --progress --files-from=last_modified user@$dest:$ruta2

