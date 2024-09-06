output "ec2_instance_ids" {
  value = module.ec2_instance.id
}

output "ec2_instance_dns" {
  value = module.ec2_instance.public_dns
}