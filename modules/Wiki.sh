#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20151119
#
# Wiki Module
#
# Cosme Faria Corrêa
# ...
#
#set -xv

#Show readme.txt, if it exists
[ -e $ModDir'Wiki/Wiki-readme.txt' ] && DisplayMsg "Wiki" "`cat $ModDir'Wiki/Wiki-readme.txt'`"

DisplayYN "EasyLife Networks - Wiki" \
"This module will:
 1) Install Wiki
 2) Create database
 3) Apply extensions
 4) Copy templates
 5) Some subs
 6) Copy Logo
" "Install" "Cancel" || return

#1 Install Wiki
yum install php-xml php-intl php-gd texlive php-xcache php-pecl-imagick mediawiki -y
ln -s /var/www/mediawiki123 /var/www/mediawiki
ln -s /usr/share/mediawiki123 /usr/share/mediawiki

#2 create/restore database
# some research is need here


#3 Apply extensions
tar -xvf $ModDir'Wiki/extensions/'LdapAuthentication-REL1_23-f266c74.tar.gz -C /usr/share/mediawiki/extensions/
tar -xvf $ModDir'Wiki/extensions/'WikiEditor-REL1_23-3f6ac7c.tar.gz -C /usr/share/mediawiki/extensions/
#tar -xvf $ModDir'Wiki/extensions/'AccessControl-REL1_23-befc02e.tar.gz -C /usr/share/mediawiki/extensions/

php /usr/share/mediawiki/maintenance/update.php --conf /var/www/mediawiki/LocalSettings.php

#4 Copy templates
# Apache conf
mv /etc/httpd/conf.d/mediawiki*.conf /etc/httpd/conf.d/mediawiki.conf 2> /dev/null
cp -p /etc/httpd/conf.d/mediawiki.conf /etc/httpd/conf.d/mediawiki.conf.`date +%Y%m%d-%H%M%S` 2> /dev/null
cat $ModDir'Wiki/templates/mediawiki.conf > /etc/httpd/conf.d/mediawiki.conf
# LocalSettings.php
cat $ModDir'Wiki/templates/LocalSettings.php > /var/www/mediawiki/LocalSettings.php
# LdapAuthentication.php
cat $ModDir'Wiki/templates/LdapAuthentication.php' > /usr/share/mediawiki/extensions/LdapAuthentication/LdapAuthentication.php

#5 Some subs
# LocalSettings.php
sed -i s/WIKISITENAME/$WIKISITENAME/g /var/www/mediawiki/LocalSettings.php
sed -i s/WIKIDBSERVER/$WIKIDBSERVER/g /var/www/mediawiki/LocalSettings.php
sed -i s/WIKIDB/$WIKIDB/g /var/www/mediawiki/LocalSettings.php
sed -i s/WIKIDBUSER/$WIKIDBUSER/g /var/www/mediawiki/LocalSettings.php
sed -i s/WIKIDBPASS/$WIKIDBPASS/g /var/www/mediawiki/LocalSettings.php
sed -i s/WIKILANGUAGE/$WIKILANGUAGE/g /var/www/mediawiki/LocalSettings.php
# LdapAuthentication.php
sed -i s/WIKILDAPLABLE/$WIKILDAPLABLE/g /usr/share/mediawiki/extensions/LdapAuthentication/LdapAuthentication.php
sed -i s/WIKILDAPSERVER/$WIKILDAPSERVER/g /usr/share/mediawiki/extensions/LdapAuthentication/LdapAuthentication.php
sed -i s/LDAPSUFIX/$LDAPSUFIX/g /usr/share/mediawiki/extensions/LdapAuthentication/LdapAuthentication.php
sed -i s/LDAPADMPASSWD/$LDAPADMPASSWD/g /usr/share/mediawiki/extensions/LdapAuthentication/LdapAuthentication.php
sed -i s/LDAPADMPASSWD/$LDAPADMPASSWD/g /usr/share/mediawiki/extensions/LdapAuthentication/LdapAuthentication.php

#6 Copy Logo
cp $ELNDIR'/media/ELN.svg /var/www/html/logowiki.svg'

#7 Start Wiki
service httpd restart

#Show postinstall.txt, if it exists
[ -e $ModDir'Wiki/Wiki-postinstall.txt' ] && DisplayMsg "Wiki" "`cat $ModDir'Wiki/Wiki-postinstall.txt'`" || ( echo 'Wiki module finished'; read )