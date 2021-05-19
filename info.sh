#!/bin/bash

BANNER=$(cat <<-END
 _____ __   _ _______  _____ 
   |   | \  | |______ |     |
 __|__ |  \_| |       |_____|
                             
END
)

tput bold
if (($(tput colors) > 8)); then
    tput setaf 208
elif (($(tput colors) == 8)); then
    tput setaf 1
fi
echo "$BANNER" $'\n'
tput sgr0

PS3="> " #La cosa del opc

echo "Selecciona una opción:"
options=("Buscar por nombre" "Buscar por PID")
select opt in "${options[@]}"
do
    case $REPLY in
        1)
            # Seleccionar nombre del proceso
			while : ; do
			    read -p "Especifíca el nombre : " name
			    if ! [[ "$name" =~ ^[A-Za-z]+$ ]]; then
			        printf "Debe ser una cadena de texto\n\n"
			    else
			    	echo "OKOKOK"
			        break
			    fi
			done

            break
            ;;
        2)
            # Seleccionar PID
			while : ; do
			    read -p "Especifíca el PID : " pid
			    if ! [[ "$pid" =~ ^[0-9]+$ ]]; then
			        printf "Debe ser un número entero\n\n"
			    else
			    	echo "OKOKOK"
			        break
			    fi
			done

            break
            ;;

        *) echo "Opcion inválida" ;;
	esac
done
