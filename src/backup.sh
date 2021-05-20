#!/bin/bash

BANNER=$(cat <<-END
___  ____ ____ _  _ _  _ ___  ____ 
|__] |__| |    |_/  |  | |__] [__  
|__] |  | |___ | \_ |__| |    ___]
END
)

function update_dir () {
    read -p "Nuevo directorio de backups [$dir]: " newdir
    newdir=${newdir:-$dir}
    if ! [[ -d $newdir ]]; then
        tput bold; echo -n "$newdir "; tput sgr0
        read -p "no existe. Desea crearlo [[y]/n]? " yn
        if ! [[ "$yn" =~ ^[Nn]$ ]]; then
            echo "Creando directorio"
            mkdir -p $newdir
        else
            return 1
        fi
    fi
    dir=${newdir}
    # https://www.gnu.org/software/sed/manual/html_node/The-_0022s_0022-Command.html
    # https://stackoverflow.com/a/5955591
    sed -i "s#^\(dir\s*=\s*\).*\$#\1$dir#m" $CONFIG_FILE
}

function backup_now () {
    read -p "Directory or file to backup: " target_dir
    if [[ -e $target_dir ]]; then
        fullpath=$(realpath $target_dir)

        echo "Backup: $fullpath"
        read -p "Confirmar [[y]/n]? " yn
        if [[ "$yn" =~ ^[Nn]$ ]]; then
            echo "Cancelando"
            return 1
        fi
        
        filebase=$(basename $fullpath)
        date_stamp=$(date '+%Y_%m_%d_%H%M')
        backup_name="${dir}/${date_stamp}_${filebase}.zip"

        echo "Generando backup: $backup_name"
        if [[ -d $fullpath ]]; then
            cd $fullpath
            zip -9qr "$backup_name" "."
            cd $OLDPWD
        else
            cd ${fullpath%/*}
            zip -9qr "$backup_name" "${fullpath##*/}"
            cd $OLDPWD
        fi
        echo "Listo! ヽ(〃･ω･)ﾉ"
    else
        echo "Direccion invalida"
    fi
}

tput bold
if (($(tput colors) > 8)); then
    tput setaf 208
elif (($(tput colors) == 8)); then
    tput setaf 1
fi
echo "$BANNER" $'\n'
tput sgr0

CONFIG_FILE="$HOME/.prometeo/backup.config"
if ! [[ -e "$CONFIG_FILE" ]]; then
    echo "Primera vez eh? (｡- ω -)... Creando configuración"
    touch "$CONFIG_FILE"
    read -p "Directorio de backups [$HOME/Backups]: " dir
    dir=${dir:-$HOME/Backups}
    if ! [[ -d $dir ]]; then
        echo "Creando $dir"
        mkdir -p $dir
    fi
    echo "dir=$dir" >> "$CONFIG_FILE"
else
    source "$CONFIG_FILE"
fi


PS3="> "
options=("Cambiar directorio de backups" "Hacer backup ahora" "Regresar")
select opt in "${options[@]}"
do
    case $REPLY in
        1) # chdir
            update_dir
            ;;
        2) # now
            backup_now
            ;;
        3)  
            break
            ;;
        *)
            echo "Opción inválida"
            ;;
    esac
done