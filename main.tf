locals {
  # Why does this exist? To codify the list of namespaces in one place and drive multiple downstream objects,
  # including policies for admin to view all namespaces
  namespace_configs = {
    "Cloud-Operations" = {
      # configure_aws      = true
      kv_group_prod_name = "38260e06-2511-4def-91c2-e37327677264"
    },
    "AppDev" = {
      # configure_gha         = true
      # gha_org               = "nphilbrook"
      kv_group_nonprod_name = "bd093061-2de9-445b-bd6c-fac871aead0b"
      kv_group_prod_name    = "a63d1663-8cfd-4007-bcc6-74b77a21586b"
    },
    "Integrations" = {
      # configure_gha = true
      # gha_org       = "nphilbrook"
    },
    "Digital-Banking" = {
    }
  }
  namespace_aws_keys = {
    "Cloud-Operations" = {
      # initial_aws_access_key_id     = var.initial_aws_access_key_id
      # initial_aws_secret_access_key = var.initial_aws_secret_access_key
    }
  }
}

module "bu_namespaces" {
  for_each = local.namespace_configs
  source   = "app.terraform.io/philbrook/bu-namespace/vault"
  version  = "3.0.1"
  # source = "git@github.com:nphilbrook/terraform-vault-bu-namespace.git?ref=main"
  # source                        = "/home/nphilbrook/repos/bankunited/terraform-vault-bu-namespace"
  name = each.key
  # configure_gha                 = try(each.value.configure_gha, false)
  # gha_org                       = try(each.value.gha_org, null)
  # configure_aws                 = try(each.value.configure_aws, false)
  # initial_aws_access_key_id     = try(each.value.configure_aws, false) ? local.namespace_aws_keys[each.key].initial_aws_access_key_id : null
  # initial_aws_secret_access_key = try(each.value.configure_aws, false) ? local.namespace_aws_keys[each.key].initial_aws_secret_access_key : null
  kv_group_prod_name    = try(each.value.kv_group_prod_name, null)
  kv_group_nonprod_name = try(each.value.kv_group_nonprod_name, null)
  # Common to all
  auth_mount_accessor = data.vault_auth_backend.saml_mount.accessor
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
