#!/bin/bash

#ver si el script es ejecutado como root
if [ "$(id -u)" -ne 0 ]; then
    echo "Este script debe ejecutarse como root"
    exit 1
fi

#verificar parametros
if [ $# -ne 3 ]; then
    echo "Parametros: usuario, grupo y archivo"
    exit 1
fi

#asignar los parametros a variables
usuario=$1
grupo=$2
archivo=$3

#verificar que el archivo exista
if [ ! -f "$archivo" ]; then
    echo "El archivo $archivo no existe"
    exit 1
fi

#verificar si el grupo existe
if ! getent group "$grupo" > /dev/null; then
    echo "El grupo $grupo no existe"
    groupadd "$grupo"
else
    echo "El grupo $grupo ya existe"
fi

#verificar si el usuario existe
if ! id -u "$usuario" > /dev/null 2>&1; then
    echo "El usuario $usuario no existe"
    useradd -m -g "$grupo" "$usuario"
else
    echo "El usuario $usuario ya existe."
    usermod -a -G "$grupo" "$usuario"
fi

chown "$usuario:$grupo" "$archivo"

chmod 750 "$archivo"

echo "El archivo $archivo ahora pertenece a $usuario:$grupo con permisos 750"
