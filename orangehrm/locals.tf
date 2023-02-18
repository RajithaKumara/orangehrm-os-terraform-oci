locals {
  platform_image_id = data.oci_core_images.autonomous_ol7.images[0].id

  is_flex_shape = contains(local.compute_flexible_shapes, var.vm_compute_shape)

  script_install_php       = "/home/${var.vm_user}/install_php74.sh"
  script_apply_patches     = "/home/${var.vm_user}/script_apply_patches.sh"
  script_install_orangehrm = "/home/${var.vm_user}/install.sh"
  script_finalize          = "/home/${var.vm_user}/finalize.sh"
  apache_orangehrm_conf    = "/home/${var.vm_user}/orangehrm.conf"
  home_dir                 = "/home/${var.vm_user}"
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
