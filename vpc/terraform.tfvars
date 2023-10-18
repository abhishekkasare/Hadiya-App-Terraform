
region = "eu-west-3"

# vpc:

vpc_cidr_block       = "10.0.0.0/16"
vpc_instance_tenancy = "default"
vpc_name             = "tf-vpc"

#availability_zones:
availability_zone_1 = "eu-west-3a"
availability_zone_2 = "eu-west-3b"

# pub_subnets:
pub_subnet1_cidr    = "10.0.1.0/24"
pub_subnet1_name    = "tf-pub1-subnet"
pub_subnet2_cidr    = "10.0.3.0/24"
pub_subnet2_name    = "tf-pub2-subnet"


# priv_subnets:
priv_subnet1_cidr   = "10.0.2.0/24"
priv_subnet1_name   = "tf-pri1-subnet"
priv_subnet2_cidr   = "10.0.4.0/24"
priv_subnet2_name   = "tf-pri2-subnet"

# pub_route_table:
pub_route_table_name = "tf-pubroute"

# priv_route_table:
priv_route_table_name = "tf-priroute"

# private instance:
priv_instance_ami      = "ami-05b5a865c3579bbc4"
priv_instance_type     = "t3.medium"
priv_instance_name     = "Jenkins-server"
