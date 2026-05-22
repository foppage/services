resource "cloudflare_zero_trust_tunnel_cloudflared" "tunnel" {
  account_id = var.cloudflare_account_id
  name       = "june.pet services"
  config_src = "cloudflare"
}

data "cloudflare_zero_trust_tunnel_cloudflared_token" "tunnel_token" {
  account_id = var.cloudflare_account_id
  tunnel_id = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "tunnel_config" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id

  config = {
    ingress = [
      {
        hostname = "id.june.pet"
        service = "http://${docker_container.pocket_id.hostname}:1411"
      },
      {
        hostname = "git.june.pet"
        service  = "http://${docker_container.forgejo.hostname}:3000",
      },
      {
        hostname = "memos.june.pet"
        service  = "http://${docker_container.memos.hostname}:5230",
      },
      {
        hostname = "paperless.june.pet"
        service = "http://${docker_container.paperless.hostname}:8000"
      },
      {
        hostname = "pdf.june.pet"
        service = "http://${docker_container.stirling-pdf.hostname}:8080"
      },
      {
        service = "http_status:404"
      }
    ]
  }
}


resource "cloudflare_dns_record" "tunnel_record" {
  zone_id = var.cloudflare_zone_id
  for_each = toset(["id", "git", "memos", "paperless", "pdf"])
  name = each.value
  content = "${cloudflare_zero_trust_tunnel_cloudflared.tunnel.id}.cfargotunnel.com"
  proxied = true
  type = "CNAME"
  ttl = 1
}

resource "docker_image" "cloudflared" {
  name = "cloudflare/cloudflared:latest"
}

resource "docker_container" "tunnel_container" {
  image = docker_image.cloudflared.image_id
  name  = "tunnel"

  networks_advanced {
    name = docker_network.cloudflared.id
  }

  command = ["tunnel", "--no-autoupdate", "run", "--token", data.cloudflare_zero_trust_tunnel_cloudflared_token.tunnel_token.token]
}