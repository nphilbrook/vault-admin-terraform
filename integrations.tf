resource "vault_jwt_auth_backend" "int_jwt_gha" {
  namespace          = module.bu_namespaces["Integrations"].path
  description        = "JWT auth backend for Github Actions"
  path               = "jwt-github"
  oidc_discovery_url = "https://token.actions.githubusercontent.com"
  bound_issuer       = "https://token.actions.githubusercontent.com"
}

resource "vault_jwt_auth_backend_role" "int_gha_role" {
  namespace         = module.bu_namespaces["Integrations"].path
  backend           = vault_jwt_auth_backend.int_jwt_gha.path
  role_name         = "gha-workflow"
  bound_audiences   = ["https://github.com/nphilbrook"]
  bound_claims_type = "glob"
  bound_claims = {
    # TODO: configure tighter sub claim here, if required
    sub                = "repo:nphilbrook/*"
    workflow           = "retrieve-vault"
    runner_environment = "self-hosted"
  }
  user_claim     = "sub"
  role_type      = "jwt"
  token_ttl      = 300
  token_type     = "service"
  token_policies = ["gha-policy"]
}

resource "vault_policy" "int_gha_policy" {
  namespace = module.bu_namespaces["Integrations"].path
  name      = "gha-policy"
  # ref below
  policy = data.vault_policy_document.int_gha_policy.hcl
}

data "vault_policy_document" "int_gha_policy" {
  rule {
    path         = "prod/kv/*"
    capabilities = ["read"]
    description  = "Read prod kv secrets"
  }

  rule {
    path         = "nonprod/kv/*"
    capabilities = ["read"]
    description  = "Read nonprod kv secrets"
  }
}
