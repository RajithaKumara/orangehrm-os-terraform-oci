locals {
  platform_image_id = data.oci_core_images.autonomous_ol7.images[0].id

  is_flex_shape = contains(local.compute_flexible_shapes, var.vm_compute_shape)

  install_orangehrm     = "/home/${var.vm_user}/install.sh"
  php_script            = "/home/${var.vm_user}/install_php74.sh"
  apache_orangehrm_conf = "/home/${var.vm_user}/orangehrm.conf"
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
