locals {
  saml_path = "saml"
}

# Fetch the current namespace, needed for the ACS Callback URL below
data "vault_namespace" "current" {}

resource "vault_saml_auth_backend" "auth0" {
  path             = local.saml_path
  idp_metadata_url = "https://dev-duhq6zvtxhjtgss0.us.auth0.com/samlp/metadata/djIEvjayGHtOJsVaaZwOWhiHvQkmaSob"
  entity_id        = "${var.vault_address}/v1/auth/saml"
  acs_urls         = ["${var.vault_address}/v1/${data.vault_namespace.current.id}saml/callback"]
  default_role     = "default"
}

# The mount accessor is not exported as an attribute on the abov resource,
# but we can fetch it.
# It's frustrating that we have to do this
data "vault_generic_secret" "saml_mount" {
  path = "sys/auth/${local.saml_path}"
}

resource "vault_saml_auth_backend_role" "default" {
  path             = vault_saml_auth_backend.auth0.path
  name             = "default"
  token_policies   = ["default"]
  groups_attribute = "http://schemas.auth0.com/vault-roles"
  # 36 hours = 60*60*36 seconds
  token_ttl = 129600
}

# break glass super admin
resource "vault_saml_auth_backend_role" "hcp_root" {
  path             = vault_saml_auth_backend.auth0.path
  name             = "vault-super-admin"
  token_policies   = ["hcp-root"]
  groups_attribute = "http://schemas.auth0.com/vault-roles"
  bound_attributes = {
    "http://schemas.auth0.com/vault-super-admin" = "true"
  }
  # 1 hours = 60*60 seconds
  # token_ttl = 3600
  # 36 hours = 60*60*36 seconds
  token_ttl = 129600
}

# External group for admins
resource "vault_identity_group" "regular_admin" {
  name     = "superadmin"
  type     = "external"
  policies = ["hcp-tf-admin"]
}

resource "vault_identity_group_alias" "regular_admin_alias" {
  name           = "vault-admin"
  mount_accessor = data.vault_generic_secret.saml_mount.data.accessor
  canonical_id   = vault_identity_group.regular_admin.id
}
