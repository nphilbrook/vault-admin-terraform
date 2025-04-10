variable "vault_address" {
  type        = string
  description = "THe address of the Vault cluster. Needed for SAML auth setup."
}

variable "initial_aws_access_key_id" {
  type        = string
  default     = null
  description = "Initial access key ID to configure AWS dynamic auth. Should be rotated via Vault API after creation."
}

variable "initial_aws_secret_access_key" {
  type        = string
  default     = null
  sensitive   = true
  description = "Initial secret access key to configure AWS dynamic auth. Should be rotated via Vault API after creation."
}
