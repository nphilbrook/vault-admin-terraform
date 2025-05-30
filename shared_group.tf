locals {
  all_kv_policies = [for ns, v in module.bu_namespaces : "${ns}-kv_prod"]
}

resource "vault_identity_group" "kv_prod_shared" {
  name     = "shared-kv-management-group"
  type     = "external"
  policies = local.all_kv_policies
}

resource "vault_identity_group_alias" "kv_prod_shared" {
  name           = "shared-kv-management-group"
  mount_accessor = data.vault_auth_backend.saml_mount.accessor
  canonical_id   = vault_identity_group.kv_prod_shared.id
}
