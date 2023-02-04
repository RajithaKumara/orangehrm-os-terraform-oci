
module "orangehrm" {
  source                         = "./orangehrm"
  tenancy_ocid                   = var.tenancy_ocid
  region                         = var.region
  compartment_ocid               = var.compartment_ocid
  availability_domain_name       = var.availability_domain_name
  vm_display_name                = var.vm_display_name
  vm_compute_shape               = var.vm_compute_shape
  vm_flex_shape_ocpus            = var.vm_flex_shape_ocpus
  vm_flex_shape_memory           = var.vm_flex_shape_memory
  ssh_authorized_keys            = var.ssh_public_key
  vcn_display_name               = var.vcn_display_name
  vcn_cidr_block                 = var.vcn_cidr_block
  vcn_dns_label                  = var.vcn_dns_label
  subnet_id                      = var.subnet_id
  subnet_display_name            = var.subnet_display_name
  subnet_cidr_block              = var.subnet_cidr_block
  subnet_dns_label               = var.subnet_dns_label
  orangehrm_admin_user_name      = "admin"
  orangehrm_admin_user_password  = "admin@123"
  orangehrm_admin_email          = "admin@example.com"
  orangehrm_admin_firstname      = "Admin"
  orangehrm_admin_lastname       = "Employee"
  orangehrm_admin_contact_number = ""
  organization_name              = "OrangeHRM"
  registration_consent           = true
}