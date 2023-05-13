#!/bin/bash
set -ex

yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(cat /etc/redhat-release  | sed 's/^[^0-9]*\([0-9]\+\).*$/\1/').noarch.rpm
yum -y install https://rpms.remirepo.net/enterprise/remi-release-$(cat /etc/redhat-release  | sed 's/^[^0-9]*\([0-9]\+\).*$/\1/').rpm

if [[ $(uname -r | sed 's/^.*\(el[0-9]\+\).*$/\1/') == "el8" ]]
then
  dnf -y module enable php:remi-8.2
  dnf -y install httpd php php-cli php-mysqlnd php-zip php-mbstring php-xml php-json php-intl
else
  yum-config-manager --enable remi-php82
  yum -y install httpd php php-cli php-mysqlnd php-zip php-mbstring php-xml php-json php-intl
fi

echo "PHP successfully installed !"
php --version

cd /var/www
rm -r html
curl -fSL -o orangehrm.zip "https://sourceforge.net/projects/orangehrm/files/stable/5.4/orangehrm-5.4.zip"
echo "24b62161728d9ceb97c6d1d7c9245d1b orangehrm.zip" | md5sum -c -
unzip -q orangehrm.zip "orangehrm-5.4/*"
mv orangehrm-5.4 orangehrm
rm -rf orangehrm.zip

echo "Configure OrangeHRM !"

# yum -y install certbot mod_ssl
# echo "Certbot has been installed !"
