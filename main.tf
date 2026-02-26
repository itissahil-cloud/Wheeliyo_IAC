module "vpc" {
  source = "./modules/vpc"

  project_name   = "wheeliyoparkx"
  vpc_cidr       = "10.10.0.0/16"

  azs = [
    "ap-south-1a",
    "ap-south-1b"
  ]

  public_subnets = [
    "10.10.1.0/24",
    "10.10.2.0/24"
  ]

  private_subnets = [
    "10.10.11.0/24",
    "10.10.12.0/24"
  ]
}