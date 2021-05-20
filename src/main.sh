#!/bin/bash
VERSION="0.6"

function get_multiline () {
    if ((BASH_VERSINFO[0] < 4)); then
        IFS=$'\n'
        read -rd '' -a strarr < $1
    else
        readarray -t strarr < $1
    fi

    len=${#strarr[0]}
}


draw_banner () {
    clear
    width=$(tput cols)
    height=$(tput lines)

    get_multiline banner.txt

    if (( len > width )); then # small mode
        get_multiline small_banner.txt
    fi


    if (( $(tput colors) > 8 )); then
        tput setaf 12
    fi

    for idx in "${!strarr[@]}"; do
        tput cup "$idx" $(((width/2) - (len/2)))
        echo "${strarr[$idx]}"
    done

    # Get cursor position
    # https://unix.stackexchange.com/a/183121
    IFS=';' read -sdR -p $'\E[6n' ROW COL

    version_tag="v$VERSION"
    len=${#version_tag}
    tput cup "${ROW#*[}" $(((width/2) - (len/2)))
    echo "$version_tag"; tput cud1; tput sgr0
}

PS3="> "
if ! [[ -d "$HOME/.prometeo" ]]; then mkdir "$HOME/.prometeo"; fi
while : ; do
    draw_banner

    options=("Borrar archivos viejos" "Backups" "Información sobre procesos" "Monitoreo" "Benchmark" "Chiste?" "Salir")
    select opt in "${options[@]}"
    do
        case $REPLY in
            1)
                /bin/bash find_old.sh; 
                break
                ;;
            2)
                /bin/bash backup.sh
                break
                ;;
            3)
                /bin/bash info.sh;
                break
                ;;
            4)
                /bin/bash monitor.sh
                break
                ;;
            5)
                /bin/bash benchmark.sh;
                break
                ;;
            6)
                /bin/bash chiste.sh;
                break
                ;;
            7)
                break 2
                ;;
            *) echo "Opcion inválida" ;;
        esac
    done
    tput setaf 3
    read -n1 -s -r -p $'Presiona cualquier tecla para regresar al menú principal...' dummy
    tput sgr0
done