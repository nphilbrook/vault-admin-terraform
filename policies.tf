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
# It includes this namespace and one level of child namespaces via the below policy documents
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

data "vault_namespaces" "children" {}

output "children" {
  value = data.vault_namespaces.children.paths
}

data "vault_policy_document" "ns_admin" {
  for_each = data.vault_namespaces.children.paths
  ### per namespace paths
  rule {
    path         = "${each.value}/sys/policies/acl*"
    capabilities = ["read", "list"]
    description  = "Read ACL policies"
  }

  rule {
    path         = "${each.value}/auth*"
    capabilities = ["read", "list"]
    description  = "Read/list auth methods broadly across Vault"
  }

  rule {
    path         = "${each.value}/sys/auth*"
    capabilities = ["read", "list"]
    description  = "List auth methods"
  }

  rule {
    path         = "${each.value}/identity*"
    capabilities = ["read", "list"]
    description  = "Read identity objects"
  }

  rule {
    path         = "${each.value}/sys/namespaces*"
    capabilities = ["read", "list"]
    description  = "Read/list namespaces"
  }

  rule {
    path         = "${each.value}/sys/mounts*"
    capabilities = ["read", "list"]
    description  = "Read/list secrets engines"
  }

  rule {
    path         = "${each.value}/sys/config/ui"
    capabilities = ["read", "list"]
    description  = "Configure Vault UI"
  }

  rule {
    path         = "${each.value}/sys/leases*"
    capabilities = ["read", "list"]
    description  = "Read/list leases"
  }

  rule {
    path         = "${each.value}/sys/health"
    capabilities = ["read"]
    description  = "Read health checks"
  }

  rule {
    path         = "${each.value}/sys/quotas*"
    capabilities = ["read", "list"]
    description  = "Read/list quotas"
  }

  rule {
    path         = "${each.value}/sys/plugins*"
    capabilities = ["read", "list"]
    description  = "Read/list plugins, if any"
  }

  rule {
    path         = "${each.value}/sys/monitor"
    capabilities = ["read"]
    description  = "Stream Vault logs"
  }

  rule {
    path         = "${each.value}/sys/managed-keys*"
    capabilities = ["read", "list"]
    description  = "Read/list managed keys"
  }

  rule {
    path         = "${each.value}/sys/locked-users*"
    capabilities = ["read", "list"]
    description  = "Read/list locked users"
  }

  rule {
    path         = "${each.value}/nonprod*"
    capabilities = ["list"]
    description  = "List things in nonprod"
  }

  rule {
    path         = "${each.value}/prod*"
    capabilities = ["list"]
    description  = "List things in prod"
  }
}

resource "vault_policy" "ns_admin" {
  for_each = data.vault_policy_document.ns_admin
  name     = "admin-${each.key}"
  policy   = data.vault_policy_document.ns_admin[each.key].hcl
}

locals {
  all_ns_admin_policies = [for p in vault_policy.ns_admin : p.name]
}
