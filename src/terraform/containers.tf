// nginx

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name = "nginx"

  hostname = "nginx"

  networks_advanced {
    name = docker_network.nginx.id
  }

  depends_on = [
    docker_container.memos,
    docker_container.paperless,
    docker_container.stirling-pdf,
    docker_container.forgejo
  ]

}

// cloudflare tunnels

resource "docker_container" "cloudflared" {
  image = docker_image.cloudflared.image_id
  name = "cloudflared"

  command = ["tunnel", "--no-autoupdate", "run", "--token", var.cloudflared_token]

  networks_advanced {
    name = docker_network.nginx.id
  }

}

// forgejo (git)

resource "docker_container" "forgejo" {
  image = docker_image.forgejo.image_id
  name = "forgejo"

  networks_advanced {
    name = docker_network.nginx.id
  }

  networks_advanced {
    name = docker_network.forgejo.id
  }

  env = [
    "USER_UID=1000",
    "USER_GID=1000",
    "FORGEJO__database__DB_TYPE=postgres",
    "FORGEJO__database__HOST=forgejo_pg:5432",
    "FORGEJO__database__NAME=forgejo",
    "FORGEJO__database__USER=forgejo",
    "FORGEJO__database__PASSWD=forgejo"
  ]

  depends_on = [
    docker_container.forgejo_pg
  ]

}

resource "docker_container" "forgejo_pg" {

  image = docker_image.postgres.image_id
  name = "forgejo_pg"

  networks_advanced {
    name = docker_network.forgejo.id
  }

  volumes {
    volume_name = docker_volume.forgejo_pg_data.id
    container_path = "/var/lib/postgresql/data"
  }

  env = [
    "POSTGRES_USER=forgejo",
    "POSTGRES_PASSWORD=forgejo",
    "POSTGRES_DB=forgejo"
  ]

}

// stirling pdf

resource "docker_container" "stirling-pdf" {
  image = docker_image.stirlingpdf.image_id
  name = "spdf"

  networks_advanced {
    name = docker_network.nginx.id
  }

}

// memos

resource "docker_container" "memos" {
  image = docker_image.memos.image_id
  name  = "memos"

  networks_advanced {
    name = docker_network.nginx.id
  }

  networks_advanced {
    name = docker_network.memos.id
  }

  env = [
    "MEMOS_DRIVER=postgres",
    "MEMOS_DSN=user=memos password=memos dbname=memosdb host=memos_db sslmode=disable"
  ]

  volumes {
    host_path = "/media/remote/memos_data"
    container_path = "/var/opt/memos"
  }

  user = "1000:1000"

  depends_on = [
    docker_container.memos_db
  ]

}

resource "docker_container" "memos_db" {
  image = docker_image.postgres.image_id
  name = "memos_db"

  networks_advanced {
    name = docker_network.memos.id
  }

  volumes {
    volume_name = docker_volume.memos_pg_data.id
    container_path = "/var/lib/postgresql/data"
  }

  env = [
    "POSTGRES_USER=memos",
    "POSTGRES_PASSWORD=memos",
    "POSTGRES_DB=memosdb"
  ]

}

// paperless

resource "docker_container" "paperless" {
  image = docker_image.paperless.image_id
  name = "paperless"

  env = [
    "USERMAP_UID=1000",
    "USERMAP_GID=1000",
    "PAPERLESS_URL=https://paperless.june.pet",
    "PAPERLESS_SECRET_KEY=${var.paperless_secret_key}",
    "PAPERLESS_TIME_ZONE=Europe/London",
    "PAPERLESS_OCR_LANGUAGE=eng",
    "PAPERLESS_REDIS=redis://paperless_redis:6379",
    "PAPERLESS_DBHOST=paperless_db"
  ]

  volumes {
    host_path = "/media/remote/paperless/data"
    container_path = "/usr/src/paperless/data"
  }

  volumes {
    host_path = "/media/remote/paperless/media"
    container_path = "/usr/src/paperless/media"
  }

  volumes {
    host_path = "/media/remote/paperless/export"
    container_path = "/usr/src/paperless/export"
  }

  volumes {
    host_path = "/media/remote/paperless/consume"
    container_path = "/usr/src/paperless/consume"
  }

  networks_advanced {
    name = docker_network.paperless.id
  }

  networks_advanced {
    name = docker_network.nginx.id
  }

  depends_on = [
    docker_container.paperless_pg,
    docker_container.paperless_redis
  ]

}

resource "docker_container" "paperless_pg" {
  image = docker_image.postgres.image_id
  name  = "paperless_db"

  env = [
    "POSTGRES_DB=paperless",
    "POSTGRES_USER=paperless",
    "POSTGRES_PASSWORD=paperless"
  ]

  networks_advanced {
      name = docker_network.paperless.id
  }

  volumes {
    volume_name = docker_volume.paperless_pg_data.id
    container_path = "/var/lib/postgresql/data"
  }

}

resource "docker_container" "paperless_redis" {
  image = docker_image.redis.image_id
  name  = "paperless_redis"

  volumes {
    volume_name = docker_volume.paperless_redis_data.id
    container_path = "/data"
  }

  networks_advanced {
    name = docker_network.paperless.id
  }

}