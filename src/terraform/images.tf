data "local_file" "nginx_conf" {
  filename = "../nginx/nginx.conf"
}

resource "terraform_data" "local_file_nginx_conf" {
  input = data.local_file.nginx_conf.content_sha256
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
  build {
    builder = "default"
    context = "../"
    dockerfile = "../docker/nginx.Dockerfile"
  }

  lifecycle {
    replace_triggered_by = [
      terraform_data.local_file_nginx_conf
    ]
  }
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

resource "docker_image" "postgres" {
  name = "postgres:latest"
}

resource "docker_image" "redis" {
  name = "redis:latest"
}