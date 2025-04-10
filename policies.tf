data "vault_policy_document" "break_glass" {
  rule {
    path         = "*"
    capabilities = ["sudo", "read", "create", "update", "delete", "list", "patch"]
    description  = "Break glass super admin policy"
  }
}

resource "vault_policy" "break_glass" {
  name   = "break-glass"
  policy = data.vault_policy_document.break_glass.hcl
}
