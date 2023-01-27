resource "oci_core_instance" "simple_vm" {
  availability_domain = local.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = var.vm_display_name
  shape               = var.vm_compute_shape

  source_details {
    source_type = "image"
    source_id   = local.platform_image_id
    #use a marketplace image or custom image:
    #source_id   = local.compute_image_id
  }

  dynamic "shape_config" {
    for_each = local.is_flex_shape
    content {
      memory_in_gbs = var.vm_flex_shape_memory
      ocpus         = var.vm_flex_shape_ocpus
    }
  }
}
