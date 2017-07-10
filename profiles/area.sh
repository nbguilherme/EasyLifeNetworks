#!/bin/bash
# Easy Life Networks
#
# Configuration Tool for an Easy Life
# Version 20170710
#
# Guilherme Barbosa
# ...
#
#set -xv

DISTROS=$(whiptail --title "Easy Life Networks" --radiolist \
"Profiles" 10 78 5 \
Gragoata "                                                    " ON \
PraiaVermelha "" OFF \
Valonguinho "" OFF \
Outros "" OFF 3>&1 1>&2 2>&3) 
exitstatus=$?
if [ $exitstatus = 0 ]; then
#    echo "The chosen mode is:" $DISTROS
    case $DISTROS in
	Gragoata )
	source profiles/areas/gragoata.sh
	;;
	PraiaVermelha )
	source profiles/areas/praiavermelha.sh
	;;
	Valonguinho )
	source profiles/areas/valonguinho.sh
	;;
	Outros )
	source profiles/areas/outros.sh
	;;
    esac
    
else
    source profiles.sh
fi

