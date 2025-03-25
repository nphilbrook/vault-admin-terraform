data "vault_policy_document" "aws_engine_admin" {
  # ======= AWS secrets engine setup =========
  rule {
    path         = "sys/mounts/aws"
    capabilities = ["create", "read", "update", "list", "delete"]
    description  = "manage AWS secrets mount"
  }

  rule {
    path         = "aws/config/root"
    capabilities = ["create", "read", "update", "list", "delete"]
    description  = "manage AWS secrets mount config"
  }

  rule {
    path         = "aws/roles*"
    capabilities = ["create", "read", "update", "list", "delete"]
    description  = "manage AWS roles"
  }
  # ======= End AWS secrets engine setup =========
}
