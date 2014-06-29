#!/bin/bash

echo "Por favor, indicame el proyecto: "
read input

proyecto="$HOME/Proyectos/$input"
turpentinepath="$HOME/Proyectos/magento-turpentine"

if [ -d "$proyecto/web" ]; then
   echo "Perfecto, vamos con $input"
else
   echo "El proyecto $proyecto no existe. Inténtalo de nuevo."
   exit
fi

cp $turpentinepath/app/etc/modules/Nexcessnet_Turpentine.xml $proyecto/web/app/etc/modules/Nexcessnet_Turpentine.xml

rsync -vaz $turpentinepath/app/code/community/Nexcessnet $proyecto/web/app/code/community/

cp $turpentinepath/app/design/adminhtml/default/default/layout/turpentine.xml $proyecto/web/app/design/adminhtml/default/default/layout/turpentine.xml

rsync -vaz $turpentinepath/app/design/adminhtml/default/default/template/turpentine $proyecto/web/app/design/adminhtml/default/default/template/

cp $turpentinepath/app/design/frontend/base/default/layout/turpentine_esi.xml $proyecto/web/app/design/frontend/base/default/layout/turpentine_esi.xml

rsync -vaz $turpentinepath/app/design/frontend/base/default/template/turpentine $proyecto/web/app/design/frontend/base/default/template/

rsync -vaz $turpentinepath/util/ $proyecto/web/shell/