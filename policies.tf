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

# This is a policy to facilitate visibility into all parts of the system for admins
# It is intentionally read-only so that write ops go through Terraform code
# It includes this namespace and one level of child namespaces
data "vault_policy_document" "admin" {
  rule {
    path         = "sys/policies/acl"
    capabilities = ["list"]
    description  = "List existing policies"
  }

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

  ### per namespace paths
  ### FIGURE OUT THE UI ERROR MESSAGE
  rule {
    path         = "+/sys/policies/acl*"
    capabilities = ["read", "list"]
    description  = "Read ACL policies"
  }

  rule {
    path         = "+/auth*"
    capabilities = ["read", "list"]
    description  = "Read/list auth methods broadly across Vault"
  }

  rule {
    path         = "+/sys/auth/*"
    capabilities = ["read", "list"]
    description  = "List auth methods"
  }

  rule {
    path         = "+/identity*"
    capabilities = ["read", "list"]
    description  = "Read identity objects"
  }

  rule {
    path         = "+/sys/namespaces/*"
    capabilities = ["read", "list"]
    description  = "Read/list namespaces"
  }

  rule {
    path         = "+/sys/mounts/*"
    capabilities = ["read", "list"]
    description  = "Read/list secrets engines"
  }

  rule {
    path         = "+/sys/config/ui"
    capabilities = ["read", "list"]
    description  = "Configure Vault UI"
  }

  rule {
    path         = "+/sys/leases*"
    capabilities = ["read", "list"]
    description  = "Read/list leases"
  }

  rule {
    path         = "+/sys/health"
    capabilities = ["read"]
    description  = "Read health checks"
  }

  rule {
    path         = "+/sys/quotas*"
    capabilities = ["read", "list"]
    description  = "Read/list quotas"
  }

  rule {
    path         = "+/sys/version-history"
    capabilities = ["read", "list"]
    description  = "List version history"
  }

  rule {
    path         = "+/sys/plugins*"
    capabilities = ["read", "list"]
    description  = "Read/list plugins, if any"
  }

  rule {
    path         = "+/sys/monitor"
    capabilities = ["read"]
    description  = "Stream Vault logs"
  }

  rule {
    path         = "+/sys/managed-keys*"
    capabilities = ["read", "list"]
    description  = "Read/list managed keys"
  }

  rule {
    path         = "+/sys/locked-users*"
    capabilities = ["read", "list"]
    description  = "Read/list locked users"
  }
}

resource "vault_policy" "admin" {
  name   = "admin"
  policy = data.vault_policy_document.admin.hcl
}
