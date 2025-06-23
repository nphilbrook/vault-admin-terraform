terraform {
  required_version = ">=1.8"
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~>4.8"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.99"
    }
  }
}
