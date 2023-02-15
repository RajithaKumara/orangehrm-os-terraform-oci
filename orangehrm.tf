
module "orangehrm" {
  source                           = "./orangehrm"
  tenancy_ocid                     = var.tenancy_ocid
  region                           = var.region
  compartment_ocid                 = var.compartment_ocid
  availability_domain_name         = local.availability_domain
  vm_display_name                  = var.vm_display_name
  vm_compute_shape                 = var.vm_compute_shape
  vm_flex_shape_ocpus              = var.vm_flex_shape_ocpus
  vm_flex_shape_memory             = var.vm_flex_shape_memory
  ssh_authorized_keys              = var.ssh_public_key
  vcn_id                           = oci_core_vcn.orangehrm_vcn[0].id
  subnet_id                        = oci_core_subnet.orangehrm_subnet[0].id
  subnet_display_name              = var.subnet_display_name
  orangehrm_admin_user_name        = var.orangehrm_admin_user_name
  orangehrm_admin_user_password    = var.orangehrm_admin_user_password
  orangehrm_admin_email            = var.orangehrm_admin_email
  orangehrm_admin_firstname        = var.orangehrm_admin_firstname
  orangehrm_admin_lastname         = var.orangehrm_admin_lastname
  orangehrm_admin_contact_number   = var.orangehrm_admin_contact_number
  organization_name                = var.instance_organization_name
  registration_consent             = var.registration_consent
  mysql_root_user_password         = var.mysql_root_user_password
  orangehrm_database_user_password = var.orangehrm_database_user_password
  mysql_hostname                   = var.mysql_hostname
  mds_ip                           = oci_mysql_mysql_db_system.mysql_db_system.ip_address
}
