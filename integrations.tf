resource "vault_jwt_auth_backend" "int_jwt_gha" {
  namespace          = module.bu_namespaces["Integrations"].path
  description        = "JWT auth backend for Github Actions"
  path               = "jwt-github"
  oidc_discovery_url = "https://token.actions.githubusercontent.com"
  bound_issuer       = "https://token.actions.githubusercontent.com"
}

module "gha_jwt_worklfow" {
  #source               = "../terraform-vault-gha-access"
  source               = "app.terraform.io/philbrook/gha-access/vault"
  version              = "1.1.1"
  vault_namespace_path = module.bu_namespaces["Integrations"].path
  jwt_backend_path     = vault_jwt_auth_backend.int_jwt_gha.path
  role_name            = "gha-workflow"
  github_organization  = "nphilbrook"
  github_repositories  = ["*"]
  write_paths          = ["nonprod/kv/*"]
  read_paths           = ["prod/kv/*"]
}

module "gha_jwt_workflow_2" {
  #source               = "../terraform-vault-gha-access"
  source               = "app.terraform.io/philbrook/gha-access/vault"
  version              = "1.1.1"
  vault_namespace_path = module.bu_namespaces["Integrations"].path
  jwt_backend_path     = vault_jwt_auth_backend.int_jwt_gha.path
  role_name            = "gha-test-addditional"
  github_organization  = "nphilbrook"
  github_repositories  = ["lambda-fib-code"]
  workflow             = "retrieve-vault-2"
}
