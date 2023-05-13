#!/bin/bash
set -ex

echo "${mds_ip}"
echo "${country}"

cd /var/www/orangehrm

INSTANCE_COUNTRY=$(php installer/console install:country-list -c "${country}" | xargs)
echo $INSTANCE_COUNTRY

sed -i 's/hostName: 127.0.0.1/hostName: "${database_hostname}"/g' installer/cli_install_config.yaml
sed -i 's/privilegedDatabaseUser: root/privilegedDatabaseUser: "${privileged_database_username}"/g' installer/cli_install_config.yaml
sed -i 's/privilegedDatabasePassword: root/privilegedDatabasePassword: "${privileged_database_user_password}"/g' installer/cli_install_config.yaml
sed -i 's/databaseName: orangehrm_mysql/databaseName: "${database_name}"/g' installer/cli_install_config.yaml
# sed -i 's/useSameDbUserForOrangeHRM: y/useSameDbUserForOrangeHRM: n/g' installer/cli_install_config.yaml
# sed -i 's/orangehrmDatabaseUser: ~/orangehrmDatabaseUser: orangehrm/g' installer/cli_install_config.yaml
# sed -i 's/orangehrmDatabasePassword: ~/orangehrmDatabasePassword: ${orangehrm_database_user_password}/g' installer/cli_install_config.yaml

sed -i 's/name: OrangeHRM/name: ${organization_name}/g' installer/cli_install_config.yaml

sed -i 's/adminUserName: Admin/adminUserName: "${orangehrm_admin_user_name}"/g' installer/cli_install_config.yaml
sed -i 's/adminPassword: Ohrm@1423/adminPassword: "${orangehrm_admin_user_password}"/g' installer/cli_install_config.yaml
sed -i 's/adminEmployeeFirstName: OrangeHRM/adminEmployeeFirstName: "${orangehrm_admin_firstname}"/g' installer/cli_install_config.yaml
sed -i 's/adminEmployeeLastName: Admin/adminEmployeeLastName: "${orangehrm_admin_lastname}"/g' installer/cli_install_config.yaml
sed -i 's/workEmail: admin@example.com/workEmail: "${orangehrm_admin_email}"/g' installer/cli_install_config.yaml
sed -i 's/contactNumber: ~/contactNumber: "${orangehrm_admin_contact_number}"/g' installer/cli_install_config.yaml
sed -i 's/registrationConsent: true/registrationConsent: ${registration_consent}/g' installer/cli_install_config.yaml
sed -i "s/country: US/country: $INSTANCE_COUNTRY/g" installer/cli_install_config.yaml

php installer/cli_install.php
