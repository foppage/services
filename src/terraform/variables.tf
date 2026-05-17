variable "paperless_secret_key" {
  type      = string
  sensitive = true
}

variable "cloudflared_token" {
  type = string
  sensitive = true
}

variable "forgejo_runner_uuid" {
  type = string,
  sensitive = true
}

variable "forgejo_runner_token" {
  type = string,
  sensitive = true
}