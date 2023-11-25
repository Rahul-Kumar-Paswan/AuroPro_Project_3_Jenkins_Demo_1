provider "aws" {
  region     = "${var.region}"
  # access_key = "${var.access_key}"
  # secret_key = "${var.secret_key}"
}

module "my_vpc" {
  source                 = "./modules/network"
  vpc_cidr_block         = local.current_env.vpc_cidr_block
  env_prefix             = local.current_env.env_prefix
  public_subnet_cidr_block     = local.current_env.public_subnet_cidr_block
  private_subnet_cidr_block = local.current_env.private_subnet_cidr_block
  public_subnet_availability_zone = local.current_env.public_subnet_availability_zone
  private_subnet_availability_zone = local.current_env.private_subnet_availability_zone
}

module "my_instance" {
    source = "./modules/instances"
    ami_id = local.current_env.ami_id
    instance_type = local.current_env.instance_type
    subnet_id = module.my_vpc.public_subnet_id
    instance_name = local.current_env.instance_name
    vpc_id = module.my_vpc.vpc_id
    env_prefix = local.current_env.env_prefix
}

/* module "my_database" {
  source                    = "./modules/database"
  vpc_id                    = module.my_vpc.vpc_id
  subnet_id_1               = module.my_vpc.public_subnet_id
  subnet_id_2                 = module.my_vpc.private_subnet_id
  env_prefix                = local.current_env.env_prefix
  db_instance_identifier    = "${var.db_instance_identifier}"
  db_allocated_storage      = "${var.db_allocated_storage}"
  db_engine                 = "${var.db_engine}"
  db_engine_version         = "${var.db_engine_version}"
  db_instance_class         = "${var.db_instance_class}"
  db_name                   = "${var.db_name}"
  db_username               = "${var.db_username}"
  db_password               = "${var.db_password}"
  db_multi_az               = "${var.db_multi_az}"
  db_backup_retention_period = "${var.db_backup_retention_period}"
  my_security_group_id      = module.my_instance.my_security_group_id
} */
