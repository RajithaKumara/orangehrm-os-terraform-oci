output "instance_id" {
  value = oci_core_instance.simple_vm.id
}

output "instance_public_ip" {
  value = oci_core_instance.simple_vm.public_ip
}

output "instance_private_ip" {
  value = oci_core_instance.simple_vm.private_ip
}

output "instance_https_url" {
  value = "https://${oci_core_instance.simple_vm.public_ip}"
}
