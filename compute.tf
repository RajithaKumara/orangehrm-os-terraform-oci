resource "oci_core_image" "test_image" {
  compartment_id = var.compute_compartment_ocid

  display_name = var.vm_display_name
  shape        = var.vm_compute_shape
}
