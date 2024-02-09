#!/bin/bash

#############################################################################################################################################################################
#███████ ██    ██ ███    ██  ██████ ████████ ██  ██████  ███    ██ ███████
#██      ██    ██ ████   ██ ██         ██    ██ ██    ██ ████   ██ ██
#█████   ██    ██ ██ ██  ██ ██         ██    ██ ██    ██ ██ ██  ██ ███████
#██      ██    ██ ██  ██ ██ ██         ██    ██ ██    ██ ██  ██ ██      ██
#██       ██████  ██   ████  ██████    ██    ██  ██████  ██   ████ ███████
#############################################################################################################################################################################
HELP() #MOSTRA IL MESSAGGIO DI AIUTO
{
    echo "Questo è un programma per cambiare in automatico la configurazione di barrier e connettere automaticamente al server IP"
    echo "È necessario un cloud per sincronizzare il file tra i dispositivi"
    echo
    echo "Opzioni:"
    echo "-h --help            Mostra questo messaggio di aiuto"
    echo ""
    echo "-s --server          Avvia il programma per il server"
    echo ""
    echo "-c --client          Avvia il programma per il client"
    echo ""
}

SERVER() #SALVA L'IP DEL SERVER NEL CLOUD
{
    cd ~/.config/Debauchee
    IP="$(hostname -I | cut -f1 -d" ")"
    echo "$IP" > ~/MEGA/barrierIp.txt
    while true
    do
        if [ "$(hostname -I | cut -f1 -d" ")" != "$IP" ];
        then
            IP="$(hostname -I | cut -f1 -d" ")"
            echo "$IP" > ~/MEGA/barrierIp.txt
        fi

        sleep 1
    done
}

CLIENT() #LEGGE L'IP DEL SERVER DAL CLIENT
{
    cd ~/.config/Debauchee
    IP=$(cat ~/MEGA/barrierIp.txt)
    killall barrier
    sed 's/.*serverHostname.*/serverHostname='"$IP"'/' Barrier.conf > Barrier1.conf && mv Barrier1.conf Barrier.conf
    barrier &
    while true
    do
        if [ "$(cat ~/MEGA/barrierIp.txt)" != "$IP" ];
        then
            IP="$(cat ~/MEGA/barrierIp.txt)"
            killall barrier
            sed 's/.*serverHostname.*/serverHostname='"$IP"'/' Barrier.conf > Barrier1.conf && mv Barrier1.conf Barrier.conf
            barrier &
        fi

        sleep 1
    done
}
#############################################################################################################################################################################
#███    ███  █████  ██ ███    ██
#████  ████ ██   ██ ██ ████   ██
#██ ████ ██ ███████ ██ ██ ██  ██
#██  ██  ██ ██   ██ ██ ██  ██ ██
#██      ██ ██   ██ ██ ██   ████
#############################################################################################################################################################################
if [ ! -z "$1" ] && [ -z "$2" ];
then
    case $1 in

    -h|--help)
        HELP
        ;;

    -s|--server)
        SERVER
        ;;

    -c|--client)
        CLIENT
        ;;

    *)
        echo "Usa -h o --help per avere la lista delle opzioni valide e sapere cosa fa il programma"
        ;;
    esac

elif [ -z "$1" ]
then
    echo "Usa -h o --help per avere la lista delle opzioni valide e sapere cosa fa il programma"
fi
#############################################################################################################################################################################
