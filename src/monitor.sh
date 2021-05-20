#!/bin/bash 
BANNER=$(cat <<-END
_  _ ____ _  _ _ ___ ____ ____ ____ ____ 
|\/| |  | |\ | |  |  |  | |__/ |___ |  | 
|  | |__| | \| |  |  |__| |  \ |___ |__|
END
)

tput bold
echo "$BANNER" $'\n'
tput sgr0
if [[ -e $HOME/.prometeo/subpid ]];then
  read -p "Deseas terminar el monitoreo? [y/[n]]: " yn
  if [[ "$yn" =~ ^[Yy]$ ]]; then
      # Sí quiere
      fin=$(cat $HOME/.prometeo/subpid)
      rm $HOME/.prometeo/subpid
      kill -2 "$fin"
      file=$(cat $HOME/.prometeo/Monitoreo.log)
      echo "$file"
  fi
else
  if (($(tput colors) > 8)); then
        tput setaf 208
  elif (($(tput colors) == 8)); then
        tput setaf 1
  fi
  while : ;do
      read -p "Directorio que será monitoreado [$HOME]: " dir
      dir=${dir:-$HOME}
      if [[ -r "$dir" ]]; then
          break
      else
          echo "Directorio inexistente o sin permiso de lectura"
      fi
  done

  bash monitor_loop.sh "$dir" & subpid=$!
  echo "$subpid" > $HOME/.prometeo/subpid
fi
