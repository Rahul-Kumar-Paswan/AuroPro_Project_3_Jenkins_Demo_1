variable "vpc_cidr_block" {}
variable "env_prefix" {
  default = "dev"
}
variable "public_subnet_cidr_block" {}
variable "private_subnet_cidr_block" {}
variable "public_subnet_availability_zone" {}
variable "private_subnet_availability_zone" {}
variable "ami_id" {}
variable "instance_type" {}
variable "instance_name" {}
# variable "private_key_path" {}
# variable "public_key_path" {}
# variable "access_key" {}
# variable "secret_key" {}
variable "region" {}
# variable "TF_VAR_private_key" {}
# variable "TF_VAR_public_key" {}


variable "db_instance_identifier" {
  default = "my-db-instance"
}

variable "db_allocated_storage" {
  default = 10
}

variable "db_engine" {
  default = "mysql"
}

variable "db_engine_version" {
  default = "5.7"
}

variable "db_instance_class" {
  default = "db.t2.micro"
}

variable "db_name" {
  default = "mydatabase"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  default = "password"
}

variable "db_multi_az" {
  default = false
}

variable "db_backup_retention_period" {
  default = 7
}



variable "environments" {
  default = {
    dev = {
      vpc_cidr_block = "10.0.0.0/16"
      env_prefix     = "dev"
      public_subnet_cidr_block = "10.0.1.0/24"
      private_subnet_cidr_block = "10.0.2.0/24"
      public_subnet_availability_zone = "ap-south-1a"
      private_subnet_availability_zone = "ap-south-1b"
      my_ip = "10.0.1.6/24"
      avail_zone = "ap-south-1a"
      instance_type = "t2.micro"
      ami_id = "ami-02e94b011299ef128"
      # instance_name = "my-first-instance"
      # private_key_path = "/root/.ssh/id_rsa"
      # public_key_path = "/root/.ssh/id_rsa.pub"
    },
    prod = {
      vpc_cidr_block = "10.0.0.0/16"
      env_prefix     = "prod"
      public_subnet_cidr_block = "10.0.1.0/24"
      private_subnet_cidr_block = "10.0.2.0/24"
      public_subnet_availability_zone = "ap-south-1a"
      private_subnet_availability_zone = "ap-south-1b"
      my_ip = "10.0.1.6/24"
      avail_zone = "ap-south-1a"
      instance_type = "t2.micro"
      ami_id = "ami-02e94b011299ef128"
      # instance_name = "my-second-instance"
      # private_key_path = "/root/.ssh/id_rsa"
      # public_key_path = "/root/.ssh/id_rsa.pub"
    }
  }
}

locals {
  current_env = lookup(var.environments, var.env_prefix, {})
}
