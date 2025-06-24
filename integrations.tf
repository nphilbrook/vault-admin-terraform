resource "vault_jwt_auth_backend" "int_jwt_gha" {
  namespace          = module.bu_namespaces["Integrations"].path
  description        = "JWT auth backend for Github Actions"
  path               = "jwt-github"
  oidc_discovery_url = "https://token.actions.githubusercontent.com"
  bound_issuer       = "https://token.actions.githubusercontent.com"
}

module "gha_oidc_access" {
  source               = "app.terraform.io/philbrook/gha-access/vault"
  version              = "1.0.1"
  vault_namespace_path = module.bu_namespaces["Integrations"].path
  jwt_backend_path     = vault_jwt_auth_backend.int_jwt_gha.path
  github_organization  = "nphilbrook"
  github_repositories  = ["*"]
}
