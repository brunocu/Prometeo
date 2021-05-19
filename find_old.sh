#!/bin/bash

BANNER=$(cat <<-END
_    _ _  _ ___  _ ____ ____    ____ ____ ____ _  _ _ _  _ ____ ____ 
|    | |\/| |__] | |__| |__/    |__| |__/ |    |__| | |  | |  | [__  
|___ | |  | |    | |  | |  \    |  | |  \ |___ |  | |  \/  |__| ___]
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
while : ;do
    read -p "Directorio a escanear [$HOME]: " dir
    dir=${dir:-$HOME}
    if [[ -r "$dir" ]]; then
        break
    else
        echo "Directorio inexistente o sin permiso de lectura"
    fi
done

echo "Antigüedad:"
options=("1 año" "6 meses" "Otro")
select opt in "${options[@]}"
do
    case $REPLY in
        1)
            old=$(find $dir -mtime +365)
            break
            ;;
        2)
            old=$(find $dir -mtime +183)
            break
            ;;
        3)
            while : ; do
                read -p "Antiguedad (dias): " n
                if ! [[ "$n" =~ ^[0-9]+$ ]]; then
                    echo "Debe ser un número entero"
                else
                    break
                fi
            done
            old=$(find $dir -mtime +$n)
            break
            ;;
    esac
    PS3="> "
done

n_files=$(echo "${old[@]}" | wc -l)

if (( "$n_files" > 10)); then
    tput smso
    read -p "Se encontraron más de 10 resultados, desea imprimirlos? [y/[n]]: " yn

    if [[ "$yn" =~ ^[Yy]$ ]]; then
        printf "\n- Archivos antiguos:\n"
        echo "${old[@]}"
        # Quieres eliminar archivo ?
        read -p "Deseas eliminar [$n_files] archivos antiguos? [y/[n]]: " yn

        if [[ "$yn" =~ ^[Yy]$ ]]; then
            # SI quiere
            echo "${old[@]}" | xargs -I {file} bash -c 'rm "{file}"'
        fi
    fi
else
    if (( "${#old}" > 0)); then
        printf "\n- Archivos antiguos:\n"
        echo "${old[@]}"
        # Quieres eliminar archivo ?
        read -p "Deseas eliminar [$n_files] archivos antiguos? [y/[n]]: " yn

        if [[ "$yn" =~ ^[Yy]$ ]]; then
            # SI quiere
            echo "${old[@]}" | xargs -I {file} bash -c 'rm "{file}"'
        fi
    else
        printf "\nNo se encontraron resultados...\n\n"
    fi
fi