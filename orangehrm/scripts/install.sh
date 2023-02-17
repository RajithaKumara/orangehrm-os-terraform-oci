#!/bin/bash
set -ex

echo '${orangehrm_admin_user_name}'
echo '${orangehrm_admin_email}'
echo '${orangehrm_admin_firstname}'
echo '${orangehrm_admin_lastname}'
echo '${orangehrm_admin_contact_number}'
echo '${organization_name}'
echo '${registration_consent}'
echo "${mds_ip}"
echo "${country}"
echo "${language}"

cd /var/www/orangehrm

sed -i 's/hostName: 127.0.0.1/hostName: ${database_hostname}/g' installer/cli_install_config.yaml
sed -i 's/privilegedDatabaseUser: root/privilegedDatabaseUser: ${privileged_database_username}/g' installer/cli_install_config.yaml
sed -i 's/privilegedDatabasePassword: root/privilegedDatabasePassword: ${privileged_database_user_password}/g' installer/cli_install_config.yaml
sed -i 's/databaseName: orangehrm_mysql/databaseName: ${database_name}/g' installer/cli_install_config.yaml
# sed -i 's/useSameDbUserForOrangeHRM: y/useSameDbUserForOrangeHRM: n/g' installer/cli_install_config.yaml
# sed -i 's/orangehrmDatabaseUser: ~/orangehrmDatabaseUser: orangehrm/g' installer/cli_install_config.yaml
# sed -i 's/orangehrmDatabasePassword: ~/orangehrmDatabasePassword: ${orangehrm_database_user_password}/g' installer/cli_install_config.yaml

sed -i 's/name: OrangeHRM/name: ${organization_name}/g' installer/cli_install_config.yaml

sed -i 's/adminUserName: Admin/adminUserName: ${orangehrm_admin_user_name}/g' installer/cli_install_config.yaml
sed -i 's/adminPassword: Ohrm@1423/adminPassword: ${orangehrm_admin_user_password}/g' installer/cli_install_config.yaml
sed -i 's/adminEmployeeFirstName: OrangeHRM/adminEmployeeFirstName: ${orangehrm_admin_firstname}/g' installer/cli_install_config.yaml
sed -i 's/adminEmployeeLastName: Admin/adminEmployeeLastName: ${orangehrm_admin_lastname}/g' installer/cli_install_config.yaml
sed -i 's/workEmail: admin@example.com/workEmail: ${orangehrm_admin_email}/g' installer/cli_install_config.yaml
sed -i 's/contactNumber: ~/contactNumber: ${orangehrm_admin_contact_number}/g' installer/cli_install_config.yaml

sed -i 's/public const PRODUCT_MODE = self::MODE_PROD/public const PRODUCT_MODE = self::MODE_DEV/g' src/lib/config/Config.php
sed -i 's/Config::SESSION_DIR => null/Config::SESSION_DIR => $pathToProjectBase . DIRECTORY_SEPARATOR . "session"/g' src/lib/config/ConfigHelper.php
sed -i 's~baseUrl: "{{ baseUrl }}"~baseUrl: "{{ baseUrl == "" ? "\/index\.php" : baseUrl }}"~g' src/plugins/orangehrmCorePlugin/templates/vue.html.twig
sed -i 's~baseUrl: "{{ baseUrl }}"~baseUrl: "{{ baseUrl == "" ? "\/index\.php" : baseUrl }}"~g' src/plugins/orangehrmCorePlugin/templates/no_header.html.twig
sed -i 's~=> $path~=> $path == "" ? "/" : $path~g' src/plugins/orangehrmCorePlugin/config/CorePluginConfiguration.php

cat installer/cli_install_config.yaml
php installer/cli_install.php

systemctl enable httpd
systemctl restart httpd

mkdir session

cd ../
chown apache:apache orangehrm
chown -R apache:apache orangehrm/src/cache orangehrm/src/log orangehrm/session
# chmod -R 775 orangehrm/src/cache orangehrm/src/log orangehrm/session

chcon -Rv --type httpd_sys_rw_content_t /var/www/orangehrm

setsebool -P httpd_can_network_connect_db 1
setsebool httpd_can_network_connect 1

firewall-cmd --add-service=http --permanent
firewall-cmd --add-service=https --permanent
firewall-cmd --reload
