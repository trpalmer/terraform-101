terraform {
  required_version = "~> 1.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2"
    }
  }
}

locals {
  product_name = "cowsay-service"
  enviroment   = "dev"
  tags = {
    product    = local.product_name
    enviroment = local.enviroment
    owner      = var.owner
  }
}

