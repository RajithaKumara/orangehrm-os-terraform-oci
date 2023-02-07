resource "oci_mysql_mysql_db_system" "mysql_db_system" {
  availability_domain = var.availability_domain_name
  compartment_id      = var.compartment_ocid
  shape_name          = "MySQL.VM.Standard.E3.1.8GB"
  subnet_id           = oci_core_subnet.simple_subnet[0].id

  admin_password = var.mysql_root_user_password
  admin_username = "root"

  hostname_label = var.mysql_hostname
}
