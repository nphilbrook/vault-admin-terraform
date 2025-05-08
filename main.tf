locals {
  # Why does this exist? To codify the list of namespaces in one place and drive multiple downstream objects,
  # including policies for admin to view all namespaces
  namespace_configs = {
    "Cloud-Operations" = {
      configure_aws = true
    },
    "AppDev" = {
      configure_gha = true
      gha_org       = "nphilbrook"
    },
    "Integrations" = {
      configure_gha = true
      gha_org       = "nphilbrook"
    },
    "Digital-Banking" = {
    }
  }
}

module "bu_namespaces" {
  for_each                      = local.namespace_configs
  source                        = "app.terraform.io/philbrook/bu-namespace/vault"
  version                       = "1.2.1"
  name                          = each.key
  configure_gha                 = try(each.value.configure_gha, null)
  gha_org                       = try(each.value.gha_org, null)
  configure_aws                 = try(each.value.configure_aws, null)
  initial_aws_access_key_id     = each.value.configure_aws ? var.initial_aws_access_key_id : null
  initial_aws_secret_access_key = each.value.configure_aws ? var.initial_aws_secret_access_key : null
  # Common to all
  auth_mount_accessor = data.vault_generic_secret.saml_mount.data.accessor
}

# module "cloud_operations" {
#   source  = "app.terraform.io/philbrook/bu-namespace/vault"
#   version = "1.2.1"
#   # source                        = "github.com/nphilbrook/terraform-vault-bu-namespace?ref=nphilbrook_gha"
#   name                          = "Cloud-Operations"
#   auth_mount_accessor           = data.vault_generic_secret.saml_mount.data.accessor
#   configure_aws                 = true
#   initial_aws_access_key_id     = var.initial_aws_access_key_id
#   initial_aws_secret_access_key = var.initial_aws_secret_access_key
# }

# module "appdev" {
#   source              = "app.terraform.io/philbrook/bu-namespace/vault"
#   version             = "1.2.1"
#   name                = "AppDev"
#   configure_gha       = true
#   gha_org             = "nphilbrook"
#   auth_mount_accessor = data.vault_generic_secret.saml_mount.data.accessor
# }

# module "integrations" {
#   source              = "app.terraform.io/philbrook/bu-namespace/vault"
#   version             = "1.2.1"
#   name                = "Integrations"
#   configure_gha       = true
#   gha_org             = "nphilbrook"
#   auth_mount_accessor = data.vault_generic_secret.saml_mount.data.accessor
# }

# module "digital_banking" {
#   source              = "app.terraform.io/philbrook/bu-namespace/vault"
#   version             = "1.2.1"
#   name                = "Digital-Banking"
#   auth_mount_accessor = data.vault_generic_secret.saml_mount.data.accessor
# }
