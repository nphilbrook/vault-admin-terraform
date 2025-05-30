# Fetch the current namespace, needed for the ACS Callback URL below
data "vault_namespace" "current" {}

resource "vault_saml_auth_backend" "saml" {
  idp_metadata_url = "https://dev-duhq6zvtxhjtgss0.us.auth0.com/samlp/metadata/djIEvjayGHtOJsVaaZwOWhiHvQkmaSob"
  entity_id        = "${var.vault_address}/v1/auth/saml"
  acs_urls         = ["${var.vault_address}/v1/${data.vault_namespace.current.id}auth/saml/callback"]
  default_role     = "default"
}

# The mount accessor is not exported as an attribute on the above resource,
# but we can fetch it.
# It's frustrating that we have to do this
data "vault_auth_backend" "saml_mount" {
  path = "saml"
}

resource "vault_saml_auth_backend_role" "default" {
  path             = vault_saml_auth_backend.saml.path
  name             = "default"
  token_policies   = ["default"]
  groups_attribute = "http://schemas.auth0.com/vault-roles"
  # 36 hours = 60*60*36 seconds
  token_ttl = 129600
}

# break glass super admin
resource "vault_saml_auth_backend_role" "break_glass" {
  path             = vault_saml_auth_backend.saml.path
  name             = "break-glass"
  token_policies   = [vault_policy.break_glass.name]
  groups_attribute = "A Garbage Value that can be anything as long as it doesn't match a real SAML attribute"
  bound_attributes = {
    "http://schemas.auth0.com/vault-super-admin" = "true"
  }
  # 1 hours = 60*60 seconds
  # token_ttl = 3600
  # 36 hours = 60*60*36 seconds
  token_ttl = 129600
}

# External group for regular admins
resource "vault_identity_group" "regular_admin" {
  name     = "admin"
  type     = "external"
  policies = concat([vault_policy.admin_admin.name], local.all_ns_admin_policies)
}

resource "vault_identity_group_alias" "regular_admin_alias" {
  name           = "vault-admin"
  mount_accessor = data.vault_auth_backend.saml_mount.accessor
  canonical_id   = vault_identity_group.regular_admin.id
}
