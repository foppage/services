resource "docker_network" "cloudflared" {
  name = "cloudflared_network"
}

resource "docker_network" "memos" {
  name = "memos_network"
}

resource "docker_network" "paperless" {
  name = "paperless_network"
}

resource "docker_network" "forgejo" {
  name = "forgejo_network"
}