variable "cloudflare_api_token" {
  type = string
  sensitive = true
}

variable "cloudflare_account_id" {
  type = string
}

variable "cloudflare_zone_id" {
  type = string
}

variable "pocket_id_encryption_key" {
  type = string
  sensitive = true
}

variable "paperless_secret_key" {
  type      = string
  sensitive = true
}

variable "paperless_oidc_client_id" {
  type = string
}

variable "paperless_oidc_client_secret" {
  type = string
  sensitive = true
}

variable "forgejo_runner_uuid" {
  type = string
}

variable "forgejo_runner_token" {
  type = string
  sensitive = true
}