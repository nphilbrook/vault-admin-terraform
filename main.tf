module "cloud_operations" {
  source  = "app.terraform.io/philbrook/bu-namespace/vault"
  version = "1.0.3"
  # source = "github.com/nphilbrook/terraform-vault-bu-namespace?ref=nphilbrook_policies"
  name                          = "Cloud-Operations"
  auth_mount_accessor           = data.vault_generic_secret.saml_mount.data.accessor
  configure_aws                 = true
  initial_aws_access_key_id     = var.initial_aws_access_key_id
  initial_aws_secret_access_key = var.initial_aws_secret_access_key
}
