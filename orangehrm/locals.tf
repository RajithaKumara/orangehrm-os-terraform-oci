locals {
  availability_domain = (var.availability_domain_name != "" ? var.availability_domain_name : data.oci_identity_availability_domain.ad.name)

  # Logic to select Oracle Autonomous Linux 7 platform image (version pegged in data source filter)
  platform_image_id = data.oci_core_images.autonomous_ol7.images[0].id

  is_flex_shape = contains(local.compute_flexible_shapes, var.vm_compute_shape)

  is_public_subnet     = true
  use_existing_network = false

  install_orangehrm = "/home/${var.vm_user}/install.sh"
  php_script        = "/home/${var.vm_user}/install_php74.sh"
}

locals {
  compute_flexible_shapes = [
    "VM.Standard3.Flex",
    "VM.Standard.E3.Flex",
    "VM.Standard.E4.Flex",
    "VM.Standard.A1.Flex",
    "VM.DenseIO.E4.Flex",
    "VM.Optimized3.Flex"
  ]
}
