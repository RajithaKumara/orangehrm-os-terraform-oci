#!/bin/bash
#set -x

yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(cat /etc/redhat-release  | sed 's/^[^0-9]*\([0-9]\+\).*$/\1/').noarch.rpm
yum -y install https://rpms.remirepo.net/enterprise/remi-release-$(cat /etc/redhat-release  | sed 's/^[^0-9]*\([0-9]\+\).*$/\1/').rpm

if [[ $(uname -r | sed 's/^.*\(el[0-9]\+\).*$/\1/') == "el8" ]]
then
  dnf -y module enable php:remi-7.4
  dnf -y install httpd php php-cli php-mysqlnd php-zip php-gd php-mcrypt php-mbstring php-xml php-json php-bcmath php-intl
else
  yum-config-manager --enable remi-php74
  yum -y install httpd php php-cli php-mysqlnd php-zip php-gd php-mcrypt php-mbstring php-xml php-json php-bcmath php-intl
fi

echo "PHP successfully installed !"
