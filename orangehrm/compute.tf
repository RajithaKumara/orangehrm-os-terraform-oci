resource "tls_private_key" "public_private_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "oci_core_instance" "orangehrm" {
  availability_domain = local.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = var.vm_display_name
  shape               = var.vm_compute_shape

  source_details {
    source_type = "image"
    source_id   = local.platform_image_id
  }

  dynamic "shape_config" {
    for_each = local.is_flex_shape ? [1] : []
    content {
      memory_in_gbs = var.vm_flex_shape_memory
      ocpus         = var.vm_flex_shape_ocpus
    }
  }

  create_vnic_details {
    subnet_id              = local.use_existing_network ? var.subnet_id : oci_core_subnet.simple_subnet[0].id
    display_name           = var.subnet_display_name
    assign_public_ip       = false
    skip_source_dest_check = false
  }

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
    user_data           = data.template_cloudinit_config.cloud_init.rendered
  }
}

resource "null_resource" "orangehrm_provisioner" {
  depends_on = [oci_core_instance.orangehrm, oci_mysql_mysql_db_system.mysql_db_system, oci_core_public_ip.orangehrm_public_ip_for_single_node]

  provisioner "file" {
    content     = data.template_file.install_php.rendered
    destination = local.php_script

    connection {
      type        = "ssh"
      host        = oci_core_public_ip.orangehrm_public_ip_for_single_node.ip_address
      agent       = false
      timeout     = "5m"
      user        = var.vm_user
      private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
  }

  provisioner "file" {
    content = templatefile(
      "${path.module}/scripts/install.sh",
      {
        orangehrm_admin_user_name        = var.orangehrm_admin_user_name
        orangehrm_admin_user_password    = var.orangehrm_admin_user_password
        orangehrm_admin_email            = var.orangehrm_admin_email
        orangehrm_admin_firstname        = var.orangehrm_admin_firstname
        orangehrm_admin_lastname         = var.orangehrm_admin_lastname
        orangehrm_admin_contact_number   = var.orangehrm_admin_contact_number
        organization_name                = var.organization_name
        registration_consent             = var.registration_consent
        mysql_hostname                   = var.mysql_hostname
        mysql_root_user_password         = var.mysql_root_user_password
        orangehrm_database_user_password = var.orangehrm_database_user_password
      }
    )
    destination = local.install_orangehrm

    connection {
      type        = "ssh"
      host        = oci_core_public_ip.orangehrm_public_ip_for_single_node.ip_address
      agent       = false
      timeout     = "5m"
      user        = var.vm_user
      private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = oci_core_public_ip.orangehrm_public_ip_for_single_node.ip_address
      agent       = false
      timeout     = "5m"
      user        = var.vm_user
      private_key = tls_private_key.public_private_key_pair.private_key_pem
    }

    inline = [
      "chmod +x ${local.php_script}",
      "sudo ${local.php_script}",
      "chmod +x ${local.install_orangehrm}",
      "sudo ${local.install_orangehrm}"
    ]

  }
}
