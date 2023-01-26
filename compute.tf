resource "oci_core_image" "test_image" {
    compartment_id = var.compartment_id

    display_name        = var.vm_display_name
    shape               = var.vm_compute_shape
}
