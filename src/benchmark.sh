#!/bin/bash

BANNER=$(cat <<-END
 _____  _____ __   _ _____  _     _ _______ ______  _____ _     _
 |____] |____ | \  | |      |_____| |  |  | |____| |____/ |____/ 
 |____] |____ |  \_| |____  |     | |  |  | |    | |   \_ |    \_
                                                                       
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

# Escoger n de pings
while : ; do
    read -ep "Especifíca el número de pings : " n
    if ! [[ "$n" =~ ^[0-9]+$ ]]; then
        echo "Debe ser un número entero"
    else
        break
    fi
done

printf "\n- Iniciando benchmark de disco... \n\n"
ioping -c "$n" . # Comenzar prueba I/O latency con "n" número de pings
