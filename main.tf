module "cloud_operations" {
  source  = "app.terraform.io/philbrook/bu-namespace/vault"
  version = "1.1.2"
  # source                        = "github.com/nphilbrook/terraform-vault-bu-namespace?ref=nphilbrook_gha"
  name                          = "Cloud-Operations"
  auth_mount_accessor           = data.vault_generic_secret.saml_mount.data.accessor
  configure_aws                 = true
  initial_aws_access_key_id     = var.initial_aws_access_key_id
  initial_aws_secret_access_key = var.initial_aws_secret_access_key
}

module "appdev" {
  source              = "app.terraform.io/philbrook/bu-namespace/vault"
  version             = "1.1.2"
  name                = "AppDev"
  configure_gha       = true
  auth_mount_accessor = data.vault_generic_secret.saml_mount.data.accessor
}

module "integrations" {
  source              = "app.terraform.io/philbrook/bu-namespace/vault"
  version             = "1.1.2"
  name                = "Integrations"
  configure_gha       = true
  auth_mount_accessor = data.vault_generic_secret.saml_mount.data.accessor
}
