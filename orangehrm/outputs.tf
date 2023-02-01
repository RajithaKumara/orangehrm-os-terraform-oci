output "instance_id" {
  value = oci_core_instance.orangehrm.id
}

output "instance_public_ip" {
  value = oci_core_instance.orangehrm.public_ip
}

output "instance_private_ip" {
  value = oci_core_instance.orangehrm.private_ip
}

output "instance_https_url" {
  value = "https://${oci_core_instance.orangehrm.public_ip}"
}
