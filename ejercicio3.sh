#!/bin/bash

# Directorio a monitorear
directorio="/home/kevin/prueba"

# Archivo de log
log_file="$directorio/log.txt"

# Monitorear el directorio usando inotifywait
while true; do
    inotifywait -e create -e modify -e delete --format '%T %e %w%f' --timefmt '%Y-%m-%d %H:%M:%S' $directorio >> $log_file
done

