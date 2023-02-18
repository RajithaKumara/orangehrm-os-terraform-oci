output "instance_id" {
  value = module.orangehrm.instance_id
}

output "instance_public_ip" {
  value = module.orangehrm.instance_public_ip
}

output "instance_private_ip" {
  value = module.orangehrm.instance_private_ip
}

output "instance_https_url" {
  value = module.orangehrm.instance_https_url
}

output "privileged_database_user_password" {
  value     = local.privileged_database_user_password
  sensitive = true
}
