# data "local_file" "nginx_conf" {
#   filename = "../nginx/nginx.conf"
# }
#
# resource "terraform_data" "local_file_nginx_conf" {
#   input = data.local_file.nginx_conf.content_sha256
# }
#
# resource "docker_image" "nginx" {
#   name = "nginx:latest"
#   build {
#     builder = "default"
#     context = "../"
#     dockerfile = "../docker/nginx.Dockerfile"
#   }
#
#   lifecycle {
#     replace_triggered_by = [
#       terraform_data.local_file_nginx_conf
#     ]
#   }
# }

resource "docker_image" "pocket_id" {
  name = "ghcr.io/pocket-id/pocket-id:v2"
}

resource "docker_image" "stirlingpdf" {
  name = "docker.stirlingpdf.com/stirlingtools/stirling-pdf:latest"
}

resource "docker_image" "memos" {
  name = "neosmemo/memos:stable"
}

resource "docker_image" "paperless" {
  name = "paperlessngx/paperless-ngx:latest"
}

resource "docker_image" "forgejo" {
  name = "codeberg.org/forgejo/forgejo:15.0.2"
}

resource "docker_image" "forgejo_runner" {
  name = "code.forgejo.org/forgejo/runner:12"
}

resource "docker_image" "docker_dind" {
  name = "docker:dind"
}

resource "docker_image" "postgres" {
  name = "postgres:latest"
}

resource "docker_image" "redis" {
  name = "redis:latest"
}