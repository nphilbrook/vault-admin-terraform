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

# These policies exist to facilitate visibility into all parts of the system for admins
# It is intentionally read-only so that write ops go through Terraform code
# It includes this namespace (top-level)
data "vault_policy_document" "admin_admin" {
  rule {
    path         = "sys/policies/acl*"
    capabilities = ["read", "list"]
    description  = "Read ACL policies"
  }

  rule {
    path         = "auth*"
    capabilities = ["read", "list"]
    description  = "Read/list auth methods broadly across Vault"
  }

  rule {
    path         = "sys/auth*"
    capabilities = ["read", "list"]
    description  = "List auth methods"
  }

  rule {
    path         = "identity*"
    capabilities = ["read", "list"]
    description  = "Read identity objects"
  }

  rule {
    path         = "sys/namespaces/*"
    capabilities = ["read", "list"]
    description  = "Read/list namespaces"
  }

  rule {
    path         = "sys/mounts*"
    capabilities = ["read", "list"]
    description  = "Read/list secrets engines"
  }

  rule {
    path         = "sys/config/ui"
    capabilities = ["read", "list"]
    description  = "Configure Vault UI"
  }

  rule {
    path         = "sys/leases*"
    capabilities = ["read", "list"]
    description  = "Read/list leases"
  }

  rule {
    path         = "sys/health"
    capabilities = ["read"]
    description  = "Read health checks"
  }

  rule {
    path         = "sys/quotas*"
    capabilities = ["read", "list"]
    description  = "Read/list quotas"
  }

  rule {
    path         = "sys/version-history"
    capabilities = ["read", "list"]
    description  = "List version history"
  }

  rule {
    path         = "sys/plugins*"
    capabilities = ["read", "list"]
    description  = "Read/list plugins, if any"
  }

  rule {
    path         = "sys/monitor"
    capabilities = ["read"]
    description  = "Stream Vault logs"
  }

  rule {
    path         = "sys/managed-keys*"
    capabilities = ["read", "list"]
    description  = "Read/list managed keys"
  }

  rule {
    path         = "sys/locked-users*"
    capabilities = ["read", "list"]
    description  = "Read/list locked users"
  }
}

resource "vault_policy" "admin_admin" {
  name   = "admin"
  policy = data.vault_policy_document.admin_admin.hcl
}

/* data "vault_policy_document" "ns_admin" {
  for_each = module.bu_namespaces
  ### per namespace paths
  rule {
    path         = "${each.key}/sys/policies/acl*"
    capabilities = ["read", "list"]
    description  = "Read ACL policies"
  }

  rule {
    path         = "${each.key}/auth*"
    capabilities = ["read", "list"]
    description  = "Read/list auth methods broadly across Vault"
  }

  rule {
    path         = "${each.key}/sys/auth*"
    capabilities = ["read", "list"]
    description  = "List auth methods"
  }

  rule {
    path         = "${each.key}/identity*"
    capabilities = ["read", "list"]
    description  = "Read identity objects"
  }

  rule {
    path         = "${each.key}/sys/namespaces*"
    capabilities = ["read", "list"]
    description  = "Read/list namespaces"
  }

  rule {
    path         = "${each.key}/sys/mounts*"
    capabilities = ["read", "list"]
    description  = "Read/list secrets engines"
  }

  rule {
    path         = "${each.key}/sys/config/ui"
    capabilities = ["read", "list"]
    description  = "Configure Vault UI"
  }

  rule {
    path         = "${each.key}/sys/leases*"
    capabilities = ["read", "list"]
    description  = "Read/list leases"
  }

  rule {
    path         = "${each.key}/sys/health"
    capabilities = ["read"]
    description  = "Read health checks"
  }

  rule {
    path         = "${each.key}/sys/quotas*"
    capabilities = ["read", "list"]
    description  = "Read/list quotas"
  }

  rule {
    path         = "${each.key}/sys/plugins*"
    capabilities = ["read", "list"]
    description  = "Read/list plugins, if any"
  }

  rule {
    path         = "${each.key}/sys/monitor"
    capabilities = ["read"]
    description  = "Stream Vault logs"
  }

  rule {
    path         = "${each.key}/sys/managed-keys*"
    capabilities = ["read", "list"]
    description  = "Read/list managed keys"
  }

  rule {
    path         = "${each.key}/sys/locked-users*"
    capabilities = ["read", "list"]
    description  = "Read/list locked users"
  }

  rule {
    path         = "${each.key}/nonprod*"
    capabilities = ["list"]
    description  = "List things in nonprod"
  }

  rule {
    path         = "${each.key}/prod*"
    capabilities = ["list"]
    description  = "List things in prod"
  }

  # AWS specific rules. These paths may not exist on all namespaces,
  rule {
    path         = "${each.key}/aws/config/rotate-root"
    capabilities = ["update"]
    description  = "Allow rotation of AWS root credentials"
  }

  rule {
    path         = "${each.key}/aws/config/root"
    capabilities = ["read"]
    description  = "Allow reading the AWS root config"
  }

  rule {
    path         = "${each.key}/aws/roles*"
    capabilities = ["read", "list"]
    description  = "Allow list and reading AWS roles"
  }
  # End AWS specific rules

  rule {
    path         = "${each.key}/sys/capabilities-self"
    capabilities = ["update"]
    description  = "Read capabilities of the token on this path in sub-namespaces. Default policy only grants this on the token namespace"
  }
}

resource "vault_policy" "ns_admin" {
  for_each = data.vault_policy_document.ns_admin
  name     = "admin-${each.key}"
  policy   = data.vault_policy_document.ns_admin[each.key].hcl
}
 */
