locals {
  availability_domain = (var.availability_domain_name != "" ? var.availability_domain_name : data.oci_identity_availability_domain.ad.name)

  # Logic to select Oracle Autonomous Linux 7 platform image (version pegged in data source filter)
  platform_image_id = data.oci_core_images.autonomous_ol7.images[0].id

  is_flex_shape = var.vm_compute_shape == "VM.Standard.E3.Flex" ? [var.vm_flex_shape_ocpus] : []

  is_public_subnet     = true
  use_existing_network = false
}
