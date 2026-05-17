variable "paperless_secret_key" {
  type      = string
  sensitive = true
}

variable "cloudflared_token" {
  type = string
  sensitive = true
}