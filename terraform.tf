terraform {
  required_version = ">=1.8"
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~>4.7.0"
    }
  }
}

provider "vault" {}
