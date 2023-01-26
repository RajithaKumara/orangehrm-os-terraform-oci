resource "oci_core_image" "test_image" {
    compartment_id = var.compartment_id
    instance_id = oci_core_instance.test_instance.id

    display_name        = var.vm_display_name
    shape               = var.vm_compute_shape
}
