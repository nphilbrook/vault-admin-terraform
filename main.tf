module "cloud_operations" {
  # source  = "app.terraform.io/philbrook/bu-namespace/vault"
  # version = "1.0.0"
  source              = "github.com/nphilbrook/terraform-vault-bu-namespace"
  name                = "Cloud-Operations"
  auth_mount_accessor = data.vault_generic_secret.saml_mount.data.accessor
}
