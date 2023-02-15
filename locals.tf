locals {
  availability_domain = (var.availability_domain_name != "" ? var.availability_domain_name : data.oci_identity_availability_domain.ad.name)

  use_existing_network = false
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
