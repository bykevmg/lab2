#!/bin/bash

#verificar que se haya pasado un argument
if [ -z "$1" ]; then
  echo "Pasa el comando para ejecutar el proceso como argumento"
  exit 1
fi

#nombre del archivo de log
LOG_FILE="consumo_log.txt"
w
#eliminar archivo de log anterior si existe
if [ -f "$LOG_FILE" ]; then
  rm "$LOG_FILE"
fi

#ejecutar el proceso en segundo plano
$1 &

#obtener el PID del ultimo proceso ejecutado
PID=$!

echo "Fecha, CPU (%), Memoria (%)" >> "$LOG_FILE"

#monitoreo del consumo de CPU y memoria
echo "Monitoreando el consumo de CPU y memoria"

#bucle para el consumo de cpu y memoria
while kill -0 $PID 2>/dev/null; do
  #obtener fecha y hora actual
  fecha=$(date '+%Y-%m-%d %H:%M:%S')

  #obtener el uso de CPU y memoria
  cpu=$(ps -p $PID -o %cpu --no-headers)
  memoria=$(ps -p $PID -o %mem --no-headers)

  #datos en el archivo de log
  echo "$fecha, $cpu, $memoria" >> "$LOG_FILE"

  sleep 1
done

echo "El proceso $PID ha terminado."

#generar el grafico con gnuplot
gnuplot -e "
  set terminal png;
  set output 'grafico.png';
  set title 'Consumo de CPU y memoria';
  set xlabel 'Tiempo';
  set ylabel 'Consumo (%)';
  set xdata time;
  set timefmt '%Y-%m-%d %H:%M:%S';
  set format x '%H:%M:%S';
  plot '$LOG_FILE' using 1:2 with lines title 'CPU', \
       '$LOG_FILE' using 1:3 with lines title 'Memoria';
"

echo " grafico.png"

