variable "tenancy_ocid" {
}

variable "region" {
}

variable "compartment_ocid" {
}

variable "tag_key_name" {
  description = "Free-form tag key name"
  default     = "App"
}

variable "tag_value" {
  description = "Free-form tag value"
  default     = "OrangeHRM"
}

############################
#  Compute Configuration   #
############################

variable "availability_domain_name" {
  default     = ""
  description = "Availability Domain name"
}

variable "vm_display_name" {
  description = "Instance Name"
  default     = "simple-vm"
}

variable "vm_compute_shape" {
  description = "Compute Shape"
  default     = "VM.Standard.E3.Flex"
}

variable "vm_flex_shape_ocpus" {
  description = "Flex Instance shape OCPUs"
  default     = 1
}

variable "vm_flex_shape_memory" {
  description = "Flex Instance shape Memory (GB)"
  default     = 6
}

variable "ssh_authorized_keys" {
  description = "Public SSH keys path to be included in the ~/.ssh/authorized_keys file for the default user on the instance. "
  default     = ""
}

variable "vm_user" {
  description = "The SSH user to connect to the master host."
  default     = "opc"
}

############################
#  Network Configuration   #
############################

variable "subnet_id" {
}

variable "vcn_id" {
}

variable "subnet_display_name" {
}

############################
#  OrangeHRM
############################

variable "orangehrm_admin_user_name" {
  default = "Admin"
}

variable "orangehrm_admin_user_password" {
  sensitive = true
}

variable "orangehrm_admin_email" {
}

variable "orangehrm_admin_firstname" {
}

variable "orangehrm_admin_lastname" {
}

variable "orangehrm_admin_contact_number" {
  default = ""
}

variable "organization_name" {
}

variable "country" {
}

variable "registration_consent" {
  default = true
}

############################
############   MDS   #######
############################

variable "privileged_database_user_password" {
  sensitive = true
}

variable "privileged_database_username" {
  default = "root"
}

variable "database_name" {
  default = "orangehrm"
}

variable "orangehrm_database_user_password" {
  default   = ""
  sensitive = true
}

variable "database_hostname" {
}

variable "mds_ip" {
}
