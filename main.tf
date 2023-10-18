
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "tf-backend-hitika"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-3"
  shared_config_files      = ["/home/neosoft/.aws/config"]
  shared_credentials_files = ["/home/neosoft/.aws/credentials"]
}

# data "terraform_remote_state" "vpc" {
#   backend = "local"
#   config = {
#       path = "/home/neosoft/terraform-project/vpc/terraform.tfstate"
#     }
#   }

module "vpc" {
  source = "./vpc"
  region = "eu-west-3"

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

}

module "rds" {
  source = "./rds"
  region                   = "eu-west-3"
  db_instance_identifier   = "tf-db"
  rds_storage_type         = "gp2"
  allocated_storage        = 20
  db_username              = "admin"
  db_password              = "password"
  rds_publicly_accessible  = false
  security_group_name      = "rds-sg"
  security_group_cidr      = "0.0.0.0/0"
  rds_engine               = "mysql"
  rds_engine_version       = "8.0.28"
  rds_instance_class       = "db.t3.micro"
  rds_parameter_group_name = "default.mysql8.0"
  rds_skip_final_snapshot  = true
  rds_option_group_name = "default:mysql-8-0"
  db_subnet_group = [module.vpc.subnet03_id, module.vpc.subnet04_id]
  vpc_id = module.vpc.vpc_id
}

module "my_ecr" {
  source = "./ecr"

  region = "eu-west-3"
  ecr    = "hadiya-backend"
}

module "my_cloudfront_s3" {
  source = "./cdn-s3"

  region                            = "eu-west-3"
  cf_origin_access_identity_comment = "MyCustomComment"
  s3_bucket_name                    = "s3-hitika-tf"
  cf_distribution_comment           = "CustomCloudFrontDistribution"
  cf_restriction_locations = ["US", "CA", "GB", "DE", "IN"]
}

module "ecs" {
  source      = "./ecs-fargate"
  vpc_id      = module.vpc.vpc_id
  public_subnets = [module.vpc.subnet01_id, module.vpc.subnet02_id]
  private_subnets = [module.vpc.subnet03_id, module.vpc.subnet04_id]
  app_count   = 1
}

