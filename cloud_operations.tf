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

locals {
  aws_account_ids = [
    "517068637116",
  ]
}

resource "vault_aws_secret_backend_role" "vault_aws_role" {
  namespace       = module.bu_namespaces["Cloud-Operations"].path
  backend         = vault_aws_secret_backend.aws.path
  name            = "aws-dynamic"
  credential_type = "assumed_role"
  role_arns       = [for account in local.aws_account_ids : "arn:aws:iam::${account}:role/s3-full-access"]
  # default_sts_ttl = 60
}

resource "vault_jwt_auth_backend_role" "vault_jwt_aws_role" {
  namespace      = module.bu_namespaces["Cloud-Operations"].path
  backend        = vault_jwt_auth_backend.jwt_hcp_tf_aws.path
  role_name      = "aws-dynamic"
  token_policies = ["default", vault_policy.aws_policy.name]

  bound_audiences = ["vault.workload.identity"]
  bound_claims = {
    sub = "organization:philbrook:project:SB Vault Lab:workspace:aws-probable-pancake:run_phase:*"
  }
  bound_claims_type = "glob"
  user_claim        = "terraform_project_id"
  role_type         = "jwt"
}

resource "vault_policy" "aws_policy" {
  namespace = module.bu_namespaces["Cloud-Operations"].path
  name      = "aws-dynamic"
  # ref below
  policy = data.vault_policy_document.aws_policy.hcl
}

data "vault_policy_document" "aws_policy" {
  rule {
    path         = "aws/creds/${vault_aws_secret_backend_role.vault_aws_role.name}"
    capabilities = ["read"]
    description  = "Read dynamic AWS credentials for the specified role"
  }

  rule {
    path         = "aws/sts/${vault_aws_secret_backend_role.vault_aws_role.name}"
    capabilities = ["read", "update", "create"]
    description  = "Read dynamic AWS credentials for the specified role with the STS path."
  }

  rule {
    path         = "aws-doormat/creds/${vault_aws_secret_backend_role.vault_aws_role.name}"
    capabilities = ["read"]
    description  = "Read dynamic AWS credentials for the specified role"
  }

  rule {
    path         = "aws-doormat/sts/${vault_aws_secret_backend_role.vault_aws_role.name}"
    capabilities = ["read", "update", "create"]
    description  = "Read dynamic AWS credentials for the specified role with the STS path."
  }
}


# DOORMAT SHIT

data "aws_iam_policy" "demo_user_permissions_boundary" {
  name = "DemoUser"
}

data "aws_iam_role" "vault_target_iam_role" {
  name = "vault-assumed-role-credentials-demo"
}

resource "aws_iam_user" "vault_mount_user" {
  name                 = "vault-root-${replace(module.bu_namespaces["Cloud-Operations"].id, "/", "-")}"
  permissions_boundary = data.aws_iam_policy.demo_user_permissions_boundary.arn
  force_destroy        = true
}

data "aws_iam_policy_document" "vault_mount_user_policy" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    resources = [
      data.aws_iam_role.vault_target_iam_role.arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "iam:GetUser",
      "iam:CreateAccessKey",
      "iam:DeleteAccessKey",
      "iam:ListAccessKeys"
    ]
    resources = [
      aws_iam_user.vault_mount_user.arn
    ]
  }
}

resource "aws_iam_policy" "vault_mount_user_policy" {
  name   = "vault-mount-user-${replace(module.bu_namespaces["Cloud-Operations"].id, "/", "-")}"
  policy = data.aws_iam_policy_document.vault_mount_user_policy.json
}

resource "aws_iam_user_policy_attachment" "vault_mount_user" {
  user       = aws_iam_user.vault_mount_user.name
  policy_arn = aws_iam_policy.vault_mount_user_policy.arn
}

# Create an access key manually here

resource "vault_aws_secret_backend" "aws_doormat" {
  path      = "aws-doormat"
  namespace = module.bu_namespaces["Cloud-Operations"].path
  # This code will no longer work for net-new invocations of this module, but I'm
  # ripping all of this stuff out anyway :shrug:
  access_key = "foo"
  secret_key = "bar"
  lifecycle {
    ignore_changes = [
      access_key,
      secret_key
    ]
  }
}

resource "vault_aws_secret_backend_role" "vault_aws_role_doormat" {
  namespace       = module.bu_namespaces["Cloud-Operations"].path
  backend         = vault_aws_secret_backend.aws_doormat.path
  name            = "aws-dynamic"
  credential_type = "assumed_role"
  role_arns       = [data.aws_iam_role.vault_target_iam_role.arn]
}
# END DOORMAT SHIT
