echo '${orangehrm_admin_user_name}'
echo '${orangehrm_admin_user_password}'
echo '${orangehrm_admin_email}'
echo '${orangehrm_admin_firstname}'
echo '${orangehrm_admin_lastname}'
echo '${orangehrm_admin_contact_number}'
echo '${organization_name}'
echo '${registration_consent}'

cd /var/www/html

sed -i 's/hostName: 127.0.0.1/hostName: ${mysql_hostname}/g' installer/cli_install_config.yaml
sed -i 's/privilegedDatabasePassword: root/privilegedDatabasePassword: ${mysql_root_user_password}/g' installer/cli_install_config.yaml
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

cat installer/cli_install_config.yaml
php installer/cli_install.php

systemctl enable httpd
systemctl restart httpd

mkdir session

cd ../
chown apache:apache html
chown -R apache:apache html/src/cache html/src/log html/session
chmod -R 775 html/src/cache html/src/log html/session

chcon -Rv --type httpd_sys_rw_content_t /var/www/html
chcon -Rv --type httpd_sys_rw_content_t /var/www/html/*

setsebool -P httpd_can_network_connect_db 1
setsebool httpd_can_network_connect 1

firewall-cmd --add-service=http --permanent
firewall-cmd --add-service=https --permanent
firewall-cmd --reload
