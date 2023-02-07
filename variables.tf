#Variables declared in this file must be declared in the marketplace.yaml
#Provide a description to your variables.

############################
#  Hidden Variable Group   #
############################
variable "tenancy_ocid" {
}

variable "region" {
}

############################
# Additional Configuration #
############################

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
  description = "Availability Domain name, if non-empty takes precedence over availability_domain_number"
}

variable "availability_domain_number" {
  default     = 1
  description = "OCI Availability Domains: 1,2,3  (subject to region availability)"
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

############################
#  Network Configuration   #
############################

variable "vcn_display_name" {
  description = "VCN Name"
  default     = "simple-vcn"
}

variable "vcn_cidr_block" {
  description = "VCN CIDR"
  default     = "10.0.0.0/16"
}

variable "vcn_dns_label" {
  description = "VCN DNS Label"
  default     = "simplevcn"
}

variable "subnet_id" {
  default = ""
}

variable "subnet_display_name" {
  description = "Subnet Name"
  default     = "simple-subnet"
}

variable "subnet_cidr_block" {
  description = "Subnet CIDR"
  default     = "10.0.0.0/24"
}

variable "subnet_dns_label" {
  description = "Subnet DNS Label"
  default     = "simplesubnet"
}


variable "ssh_public_key" {
  description = "SSH Public Key"
  default     = ""
}

variable "vm_user" {
  description = "The SSH user to connect to the master host."
  default     = "opc"
}
