# barrier-auto

## Barrier automatic connection

Simple pure bash script to synchronize devices and automatically connect them to the server at boot. <br />
It is especially useful for those who often change networks and travel with multiple devices. <br />
For example with a Linux tablet, in order to automatically use the mouse and keyboard between the two devices automatically. <br />


```
#!/bin/bash

#############################################################################################################################################################################
#███████ ██    ██ ███    ██  ██████ ████████ ██  ██████  ███    ██ ███████
#██      ██    ██ ████   ██ ██         ██    ██ ██    ██ ████   ██ ██
#█████   ██    ██ ██ ██  ██ ██         ██    ██ ██    ██ ██ ██  ██ ███████
#██      ██    ██ ██  ██ ██ ██         ██    ██ ██    ██ ██  ██ ██      ██
#██       ██████  ██   ████  ██████    ██    ██  ██████  ██   ████ ███████
#############################################################################################################################################################################
HELP()
{
    echo "This is a program to automatically change the barrier configuration and automatically connect to the IP server"
    echo "A cloud is required to sync the file between devices"
    echo
    echo "Options:"
    echo "-h --help            Show this help message"
    echo ""
    echo "-s --server          Start the server program"
    echo ""
    echo "-c --client          Start the client program"
    echo ""
}

SERVER() #SAVE THE SERVER IP IN THE CLOUD
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

CLIENT() #READS THE SERVER IP FROM THE CLOUD
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
        echo "Use -h or --help to get the list of valid options and know what the program does"
        ;;
    esac

elif [ -z "$1" ]
then
    echo "Use -h or --help to get the list of valid options and know what the program does"
fi
#############################################################################################################################################################################

```
