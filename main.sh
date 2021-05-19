#!/bin/bash
VERSION="0.1"

clear
width=$(tput cols)
height=$(tput lines)

draw_banner () {
    if ((BASH_VERSINFO[0] < 4)); then
        IFS=$'\n'
        read -rd '' -a banarr < banner.txt
    else
        readarray -t banarr < banner.txt
    fi

    len=${#banarr[0]}

    if (( $(tput colors) > 8 )); then
        tput setaf 12
    fi
    for idx in "${!banarr[@]}"; do
        tput cup $idx $(((width/2) - (len/2)))
        echo "${banarr[$idx]}"
    done

    # Get cursor position
    # https://unix.stackexchange.com/a/183121
    IFS=';' read -sdR -p $'\E[6n' ROW COL

    version_tag="v$VERSION"
    len=${#version_tag}
    tput cup "${ROW#*[}" $(((width/2) - (len/2)))
    echo "$version_tag"; tput cud1; tput sgr0
}

draw_banner

PS3="> "
options=("Borrar archivos viejos" "Backups" "Información sobre proceso" "Buscar procesos" "Monitoreo" "Salir")
select opt in "${options[@]}"
do
    case $REPLY in
        1)
            ;;
        2)
            ;;
        3)
            ;;
        4)
            ;;
        5)
            ;;
        6)
            echo "Adios"; break
            ;;
        *) echo "Opcion inválida" ;;
    esac
done
