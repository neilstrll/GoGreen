
module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "5.5.0"
  name                 = "vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = ["us-west-2"]
}