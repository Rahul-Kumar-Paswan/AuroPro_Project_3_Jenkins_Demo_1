region     = "ap-south-1"

vpc_cidr_block                   = "10.0.0.0/16"
env_prefix                       = "dev"
public_subnet_cidr_block         = "10.0.1.0/24"
private_subnet_cidr_block        = "10.0.2.0/24"
public_subnet_availability_zone  = "ap-south-1a"
private_subnet_availability_zone = "ap-south-1b"

ami_id           = "ami-02e94b011299ef128" # Replace with your AMI ID
instance_type    = "t2.micro"
instance_name    = "my-third-instance"  # Replace with your instance name
# private_key_path = "/root/.ssh/id_rsa"
# public_key_path = "/root/.ssh/id_rsa.pub"


db_instance_identifier      = "my-db-instance"
db_allocated_storage        = 10
db_engine                   = "mysql"
db_engine_version           = "5.7"
db_instance_class           = "db.t2.micro"
db_name                     = "mydatabase"
db_username                 = "admin"
db_password                 = "password"
db_multi_az                 = false
db_backup_retention_period  = 7