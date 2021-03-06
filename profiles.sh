#!/bin/bash
# Easy Life Networks
#
# Configuration Tool for an Easy Life
# Version 20150923
#
# Cosme Faria Corrêa
# ...
#
#set -xv

DISTROS=$(whiptail --title "Easy Life Networks" --radiolist \
"Profiles" 10 78 5 \
Simple "Easy design for a limited wireless network" ON \
Central "Central Machine with Controller and Monitoring" OFF \
Master "Central Machine for usae with a slave" OFF \
Slave "Central Machine for usae with a master" OFF \
Area "Area Machine" OFF 3>&1 1>&2 2>&3) 
exitstatus=$?
if [ $exitstatus = 0 ]; then
#    echo "The chosen mode is:" $DISTROS
    case $DISTROS in
	Simple )
	source profiles/simple.sh
	;;
	Central )
	source profiles/central.sh
	;;
	Master )
	source profiles/master.sh
	;;
	Slave )
	source profiles/slave
	;;
	Area )
	source profiles/area.sh
	;;
    esac
    
else
    source eln.sh
fi
