resource "vault_jwt_auth_backend" "jwt_hcp_tf_aws" {
  namespace          = module.bu_namespaces["Cloud-Operations"].path
  description        = "JWT auth backend for HCP Terraform to provision dynamic AWS creds"
  path               = "jwt"
  oidc_discovery_url = "https://app.terraform.io"
  bound_issuer       = "https://app.terraform.io"
}

resource "vault_aws_secret_backend" "aws" {
  namespace  = module.bu_namespaces["Cloud-Operations"].path
  access_key = var.initial_aws_access_key_id
  secret_key = var.initial_aws_secret_access_key
  lifecycle {
    ignore_changes = [
      access_key,
      secret_key
    ]
  }
}

# A role for the TFC-Workspace-Admin workspace 
resource "vault_jwt_auth_backend_role" "tfc_workspace_admin_role" {
  namespace = module.bu_namespaces["Cloud-Operations"].path
  backend   = vault_jwt_auth_backend.jwt_hcp_tf_aws.path
  role_name = "tfc-workspace-admin"

  token_policies = [
    vault_policy.tfc_workspace_admin_policy.name
  ]

  bound_audiences = ["vault.workload.identity"]
  bound_claims = {
    sub = "organization:philbrook:project:*:workspace:hcp-tf-control:run_phase:*"
  }

  bound_claims_type = "glob"
  user_claim        = "terraform_workspace_id"
  role_type         = "jwt"
}

resource "vault_policy" "tfc_workspace_admin_policy" {
  namespace = module.bu_namespaces["Cloud-Operations"].path
  name      = "tfc-workspace-admin"
  policy    = data.vault_policy_document.tfc_workspace_admin_policy.hcl
}

data "vault_policy_document" "tfc_workspace_admin_policy" {
  rule {
    path         = "auth/jwt/role*"
    capabilities = ["create", "read", "update", "patch", "list", "delete"]
    description  = "manage JWT roles in the Cloud-Operations namespace for TFC workspaces"
  }

  rule {
    path         = "sys/policies/acl*"
    capabilities = ["create", "read", "update", "patch", "list", "delete"]
    description  = "manage policies in the Cloud-Operations namespace for TFC workspaces"
  }
  rule {
    path         = "aws/roles*"
    capabilities = ["create", "read", "update", "patch", "list", "delete"]
    description  = "manage AWS roles in the Cloud-Operations namespace for TFC workspaces"
  }
}

module "aws_roles" {
  source          = "app.terraform.io/philbrook/aws-engine-roles/vault"
  version         = "1.0.1"
  tf_organization = "philbrook"
  tf_workspaces = [
    "aws-probable-pancake",
    "aws-delightful-otter"
  ]
  aws_iam_role_name    = "s3-full-access"
  aws_account_id       = "517068637116"
  vault_namespace_path = module.bu_namespaces["Cloud-Operations"].path
}

