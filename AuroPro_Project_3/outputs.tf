output "vpc_id" {
  value = module.my_vpc.vpc_id
}

output "public_subnet_id" {
  value = module.my_vpc.public_subnet_id
}

output "private_subnet_id" {
  value = module.my_vpc.private_subnet_id
}

output "public_ip" {
  value = module.my_instance.public_ip
}

output "private_ip" {
  value = module.my_instance.private_ip
}

output "private_key_pem" {
  value = module.my_instance.private_key_pem
  sensitive = true
}

# output "db_instance_endpoint" {
#   value = module.my_db_instance.db_instance_endpoint
# }

output "db_instance_endpoint" {
  value = module.my_database.db_instance_endpoint
}