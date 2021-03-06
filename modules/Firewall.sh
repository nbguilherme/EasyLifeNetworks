#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20151114
#
# Firewall module
#
# Cosme Faria Corrêa - cosmefc@id.uff.br
# John Doe
# ...
#
#set -xv        

clear

DisplayYN "EasyLife Networks - Firewall " \
"This module will :
 1) Set FirewallB package
 2) Install FirewallB
 3) Setup FW
 4) Setup firewall logrotate
 5) Start
" "Install" "Cancel" || exit


#1 Set FirewallB package
if [ $OSVERSION = "7" ]; then
#    wget ftp://mirror.switch.ch/pool/4/mirror/fedora/linux/releases/22/Everything/x86_64/os/Packages/f/fwbuilder-5.1.0.3599-5.fc20.x86_64.rpm
    FW='fwbuilder-5.1.0.3599-5.fc20.x86_64.rpm'
else
#    wget  http://ufpr.dl.sourceforge.net/project/fwbuilder/Current_Packages/5.1.0/fwbuilder-5.1.0.3599-1.el6.x86_64.rpm
    FW='fwbuilder-5.1.0.3599-1.el6.x86_64.rpm'
fi

#2 Install FirewallB
#yum localinstall fwbuilder-5.1.0.3599*.rpm -y
yum localinstall $ModDir/Firewall/"$FW" -y

#3 Setup FirewallB
cp -p $ModDir/Firewall/firewall /etc/init.d/

#4 Setup logrotate
rm /etc/logrotate.d/iptables 2> /dev/null
cp -p $ModDir/Firewall/firewall.logrotate /etc/logrotate.d/iptables

#5 start FB
case $OSVERSION in
    6 )
      service iptables stop
      service ip6tables stop
      chkconfig iptables off
      chkconfig ip6tables off
      ;;
    7 )
      systemctl stop  firewalld.service
      systemctl disable firewalld.service
      ;;
esac

chkconfig firewall on


cat <<-EOF

Firewall module finished

You must:
- choose your firewall in /root/FirewallTemplates/
- save as /root/firewall.fwb
- study, modify and compile
- copy firewall.fw to /etc/init.d/
- restart firewall
  - service firewall restart 

Press <Enter> to exit

EOF
read
