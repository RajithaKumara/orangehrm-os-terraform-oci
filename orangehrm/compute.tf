resource "tls_private_key" "public_private_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "oci_core_instance" "orangehrm" {
  availability_domain = var.availability_domain_name
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
    subnet_id              = var.subnet_id
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
  depends_on = [oci_core_instance.orangehrm, oci_core_public_ip.orangehrm_public_ip_for_single_node]

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
        orangehrm_admin_user_name         = var.orangehrm_admin_user_name
        orangehrm_admin_user_password     = var.orangehrm_admin_user_password
        orangehrm_admin_email             = var.orangehrm_admin_email
        orangehrm_admin_firstname         = var.orangehrm_admin_firstname
        orangehrm_admin_lastname          = var.orangehrm_admin_lastname
        orangehrm_admin_contact_number    = var.orangehrm_admin_contact_number
        organization_name                 = var.organization_name
        country                           = var.country
        language                          = var.language
        registration_consent              = var.registration_consent
        database_hostname                 = var.database_hostname
        privileged_database_user_password = var.privileged_database_user_password
        privileged_database_username      = var.privileged_database_username
        database_name                     = var.database_name
        mds_ip                            = var.mds_ip
        orangehrm_database_user_password  = var.orangehrm_database_user_password
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

  provisioner "file" {
    content     = file("${path.module}/scripts/orangehrm.conf")
    destination = local.apache_orangehrm_conf

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
      "sudo ${local.install_orangehrm}",
      "sudo mv ${local.apache_orangehrm_conf} /etc/httpd/conf.d/orangehrm.conf",
      "sudo chown root:root /etc/httpd/conf.d/orangehrm.conf",
      "sudo chcon -v -t httpd_sys_rw_content_t /etc/httpd/conf.d/orangehrm.conf",
      "sudo systemctl restart httpd"
    ]

  }
}

resource "oci_core_public_ip" "orangehrm_public_ip_for_single_node" {
  depends_on     = [oci_core_instance.orangehrm]
  compartment_id = var.compartment_ocid
  display_name   = "orangehrm_public_ip_for_single_node"
  lifetime       = "RESERVED"
  private_ip_id  = data.oci_core_private_ips.orangehrm_private_ips1.private_ips[0]["id"]
}
