resource "oci_mysql_mysql_db_system" "mysql_db_system" {
  availability_domain = var.availability_domain_name
  compartment_id      = var.compartment_ocid
  shape_name          = var.mysql_shape
  subnet_id           = oci_core_subnet.orangehrm_subnet[0].id
  configuration_id    = oci_mysql_mysql_configuration.mysql_configuration.id

  admin_password = local.privileged_database_user_password
  admin_username = var.privileged_database_username

  hostname_label = var.database_hostname
}

resource "oci_mysql_mysql_configuration" "mysql_configuration" {
  compartment_id = var.compartment_ocid
  shape_name     = var.mysql_shape

  display_name = "MDS terraform configuration"

  variables {
    sql_mode = "STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION"
  }
}

resource "random_password" "mysql_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*-_=+"
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
}
