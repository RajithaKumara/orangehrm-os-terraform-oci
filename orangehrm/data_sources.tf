data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = var.availability_domain_number
}

data "oci_core_images" "autonomous_ol7" {
  compartment_id   = var.compartment_ocid
  operating_system = "Oracle Autonomous Linux"
  sort_by          = "TIMECREATED"
  sort_order       = "DESC"
  state            = "AVAILABLE"

  # filter restricts to OL 7
  filter {
    name   = "operating_system_version"
    values = ["7\\.[0-9]"]
    regex  = true
  }
}

data "template_file" "install_orangehrm" {
  template = file("${path.module}/scripts/install.sh")

  vars = {
    admin_user_name      = var.orangehrm_admin_user_name
    admin_user_password  = var.orangehrm_admin_user_password
    admin_email          = var.orangehrm_admin_email
    admin_firstname      = var.orangehrm_admin_firstname
    admin_lastname       = var.orangehrm_admin_lastname
    admin_contact_number = var.orangehrm_admin_contact_number
    organization_name    = var.organization_name
    registration_consent = var.registration_consent
  }
}

data "template_file" "install_php" {
  template = file("${path.module}/scripts/install_php74.sh")
}

data "template_file" "key_script" {
  template = file("${path.module}/scripts/sshkey.tpl")
  vars = {
    ssh_public_key = tls_private_key.public_private_key_pair.public_key_openssh
  }
}

data "template_cloudinit_config" "cloud_init" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "ainit.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.key_script.rendered
  }
}
