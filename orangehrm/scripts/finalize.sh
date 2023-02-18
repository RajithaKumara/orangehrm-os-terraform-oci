#!/bin/bash
set -ex

systemctl enable httpd

cd /var/www
chown apache:apache orangehrm
chown -R apache:apache orangehrm/var
chcon -Rv --type httpd_sys_rw_content_t /var/www/orangehrm

setsebool -P httpd_can_network_connect_db 1
setsebool httpd_can_network_connect 1

firewall-cmd --add-service=http --permanent
firewall-cmd --add-service=https --permanent
firewall-cmd --reload

sed -i '/expose_php = On/c\expose_php = Off' /etc/php.ini
sed -i 's~DocumentRoot "/var/www/html"~DocumentRoot "/var/www/orangehrm/web"~' /etc/httpd/conf/httpd.conf

mv ${apache_orangehrm_conf} /etc/httpd/conf.d/orangehrm.conf
chown root:root /etc/httpd/conf.d/orangehrm.conf
chcon -v -t httpd_sys_rw_content_t /etc/httpd/conf.d/orangehrm.conf

systemctl restart httpd
