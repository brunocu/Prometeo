#!/bin/bash 
BANNER=$(cat <<-END
_  _ ____ _  _ _ ___ ____ ____ ____ ____ 
|\/| |  | |\ | |  |  |  | |__/ |___ |  | 
|  | |__| | \| |  |  |__| |  \ |___ |__|
END
)
if (($(tput colors) > 8)); then
	tput setaf 208
elif (($(tput colors) == 8)); then
	tput setaf 1
fi
tput bold
echo "$BANNER" $'\n'
tput sgr0
#Se comprueba si el proceso de monitoreo ya está funcionando,
#El PID del monitoreo se almacena en el archivo /subpid.
if [[ -e $HOME/.prometeo/subpid ]] && [[ -s $HOME/.prometeo/subpid ]];then
  #Se pregunta si se desea terminar el monitoreo.
  read -p "Deseas terminar el monitoreo? [y/[n]]: " yn
  if [[ "$yn" =~ ^[Yy]$ ]]; then
      # Sí quiere
      fin=$(cat $HOME/.prometeo/subpid)
      #AL finalizar el proceso se elimina el archivo correspondiente al PID.
      rm $HOME/.prometeo/subpid
      #Se elimina el proceso de monitoreo.
      kill -15 "$fin"
      #Se muestra el archivo log que almacena los archivos modificados.
      file=$(cat $HOME/.prometeo/Monitoreo.log)
      echo "$file"
  fi
else
  while : ;do
      #Inserción de directorio a monitorear
      read -p "Directorio que será monitoreado [$HOME]: " dir
      dir=${dir:-$HOME}
      if [[ -r "$dir" ]]; then
          break
      else
          echo "Directorio inexistente o sin permiso de lectura"
      fi
  done
  #Se ejecuta el archivo que se encarga de realizar el monitoreo.
  #Dicho proceso se realiza en segundo plano, y se almacena su PID para
  #poder finalizar el proceso cuando sea deseado, otorgando la facilidad de
  #continuar trabajando en la terminal sin necesidad de prestar atención a
  #su ejecución.
  bash monitor_loop.sh "$dir" & subpid=$!
  echo "$subpid" > $HOME/.prometeo/subpid
  echo "El monitoreo se realizará en segundo plano, para finalizarlo accede nuevamente a esta opción"
fi
