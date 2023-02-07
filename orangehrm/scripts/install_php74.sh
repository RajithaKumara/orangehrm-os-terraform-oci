#!/bin/bash
#set -x

yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(cat /etc/redhat-release  | sed 's/^[^0-9]*\([0-9]\+\).*$/\1/').noarch.rpm
yum -y install https://rpms.remirepo.net/enterprise/remi-release-$(cat /etc/redhat-release  | sed 's/^[^0-9]*\([0-9]\+\).*$/\1/').rpm

if [[ $(uname -r | sed 's/^.*\(el[0-9]\+\).*$/\1/') == "el8" ]]
then
  dnf -y module enable php:remi-7.4
  dnf -y install httpd php php-cli php-mysqlnd php-zip php-mbstring php-xml php-json php-intl
else
  yum-config-manager --enable remi-php74
  yum -y install httpd php php-cli php-mysqlnd php-zip php-mbstring php-xml php-json php-intl
fi

echo "PHP successfully installed !"

cd /var/www
rm -r html
curl -fSL -o orangehrm.zip "https://sourceforge.net/projects/orangehrm/files/stable/5.3/orangehrm-5.3.zip"
echo "82f2739e3f8ce4429b283863689ab5a1 orangehrm.zip" | md5sum -c -
unzip -q orangehrm.zip "orangehrm-5.3/*"
mv orangehrm-5.3 html
rm -rf orangehrm.zip

echo "Configure OrangeHRM !"
