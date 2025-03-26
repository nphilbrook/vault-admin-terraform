terraform {
  cloud {
    organization = "philbrook"

    workspaces {
      project = "SB Vault Lab"
      name    = "vault-admin-terraform-testing"
    }
  }
}
