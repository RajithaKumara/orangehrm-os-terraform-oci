echo '${orangehrm_admin_user_name}'
echo '${orangehrm_admin_user_password}'
echo '${orangehrm_admin_email}'
echo '${orangehrm_admin_firstname}'
echo '${orangehrm_admin_lastname}'
echo '${orangehrm_admin_contact_number}'
echo '${organization_name}'
echo '${registration_consent}'

systemctl start httpd
systemctl enable httpd
