locals {
  # Why does this exist? To codify the list of namespaces in one place and drive multiple downstream objects,
  # including policies for admin to view all namespaces
  namespace_configs = {
    "Cloud-Operations" = {
      kv_group_prod_name = "38260e06-2511-4def-91c2-e37327677264"
    },
    "AppDev" = {
      kv_group_nonprod_name      = "bd093061-2de9-445b-bd6c-fac871aead0b"
      kv_group_prod_name         = "a63d1663-8cfd-4007-bcc6-74b77a21586b"
      namespace_admin_group_name = "a63d1663-8cfd-4007-bcc6-74b77a21586b"
    },
    "Integrations" = {
    },
    "Digital-Banking" = {
    }
  }
  namespace_aws_keys = {
    "Cloud-Operations" = {
    }
  }
}

module "bu_namespaces" {
  for_each = local.namespace_configs
  /*   source   = "app.terraform.io/philbrook/bu-namespace/vault"
  version  = "3.1.0" */
  source = "git@github.com:nphilbrook/terraform-vault-bu-namespace.git?ref=main"
  # source                        = "/home/nphilbrook/repos/bankunited/terraform-vault-bu-namespace"
  name                       = each.key
  kv_group_prod_name         = try(each.value.kv_group_prod_name, null)
  kv_group_nonprod_name      = try(each.value.kv_group_nonprod_name, null)
  namespace_admin_group_name = try(each.value.namespace_admin_group_name, null)
  # Common to all
  auth_mount_accessor = data.vault_auth_backend.saml_mount.accessor
}
