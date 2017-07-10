#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20170710
#
# Area configuration - Gragoata
#
# Guilherme Barbosa
#
# ...
#
#set -xv

DisplayYN "Gragoata" \
"This profile will setup the following configurations for the Gragoatá campus:

 1) Networks

 2) DNSMasq
 
 3) Firewall

 4) Denyhosts
	
 5) SSH

$TAIL" "Confirm" "Cancel" || exit 

#
#Start Configuration
#

###############################
#Networks
###############################

#1 some analysis
ETHERINT=`nmcli device status | grep ethernet | tr -s " "| cut -d' ' -f 4-`
c=$IFS
NOI=0
IFS=$'\n'
for i in $ETHERINT; do
    NOI=$((NOI+1))
    INT[NOI]=`echo $i | xargs`
done
IFS=$c

#2 Setup External Interface
nmcli connection delete "${INT[1]}" #deletando o nome da INTEXT
nmcli connection add type ethernet con-name "${INT[1]}" ifname $EXTINT ip4 "$EXTIP""/""$EXTMASKB" gw4 "$IGIP" 
nmcli connection modify "${INT[1]}" ipv4.dns "$DNSSERVER" #DNS
nmcli connection modify "${INT[1]}" ipv6.method ignore # Turn off ipv6

#3 Setup Internal Interface
if [ $NOI -ge 2 ]; then
	nmcli connection delete "${INT[2]}"
	nmcli connection add type ethernet con-name "${INT[2]}" ifname $INTINT ip4 "$INTIP""/""$INTMASKB"
	nmcli connection modify "${INT[2]}" ipv6.method ignore # Turn off ipv6
fi

#4 Setup Monitoring Interface
if [ $NOI -ge 3 ]; then
    nmcli connection delete "${INT[3]}"
    nmcli connection add type ethernet con-name "${INT[3]}" ifname $MONINT ip4 "$MONIP""/""$MONMASKB"
    nmcli connection modify "${INT[3]}" ipv6.method ignore # Turn off ipv6
fi

#5 Setup hostname and default gateway
hostnamectl set-hostname $MACHINE.$DOMAINWIFI 
 
echo "$INTIP $MACHINE.$DOMAINWIFI $MACHINE" >> /etc/hosts
sed -i s/$IGIP/'#'$IGIP/g /etc/hosts
echo $IGIP' '$IGNAME' #'" Added by ELN - `date +%Y%m%d-%H%M%S`" >> /etc/hosts #Put default gateway name in hosts


##############################
#DNSMasq
##############################

# Install DNSMasq
yum install dnsmasq -y

# Setup DNSMasq
mv /etc/dnsmasq.conf /etc/dnsmasq.conf.`date +%Y%m%d-%H%M%S`
cp $ModDir/DNSMasq/dnsmasq.conf /etc/
# External Inteface
sed -i s/EXTINT/$EXTINT/g /etc/dnsmasq.conf
# Wifi Domain
sed -i s/DOMAINWIFI/$DOMAINWIFI/g /etc/dnsmasq.conf

# Setup DNSMasq start
chkconfig dnsmasq on
service dnsmasq restart



##############################
#Firewall
##############################





##############################
#Denyhosts
##############################


#1 Install DenyHosts
yum install denyhosts -y

#2 Copy Templates
mv /etc/denyhosts.conf /etc/denyhosts.`date +%Y%m%d-%H%M%S`
cp -p $ModDir'DenyHosts/denyhosts.conf'  /etc/ 

#4
sed -i s/LOCKTIME/$LOCKTIME/g /etc/denyhosts.conf

#4 Setup LogRotate
rm /etc/logrotate.d/denyhosts
cp -p $ModDir/DenyHosts/denyhosts.logrotate /etc/logrotate.d/denyhosts

#5 Start
chkconfig denyhosts on
service denyhosts restart



##############################
#SSH
##############################


#1 Install openssh-server
yum install openssh-server -y

#2
mv /etc/ssh/sshd_config /etc/ssh/sshd_config.`date +%Y%m%d-%H%M%S` 2>/dev/null
cp -p $ModDir/SSHD/sshd_config /etc/ssh/

#3
#sed -i s/SSHDGROUP/$SSHDGROUP/g /etc/ssh/sshd_config
case "$SSHDAUTH" in
	[gG])
		ALLOWAUTH="AllowGroups "$SSHDGROUP
		;;
	[uU])
		ALLOWAUTH="AllowUsers "$SSHDUSERS
		;;
esac
sed -i s/ALLOWAUTH/"$ALLOWAUTH"/g /etc/ssh/sshd_config

#4
chkconfig sshd on
service sshd restart




