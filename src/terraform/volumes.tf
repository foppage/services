resource "docker_volume" "forgejo_data" {
  name = "forgejo-data"
  lifecycle {
    prevent_destroy = true
  }
}

resource "docker_volume" "forgejo_pg_data" {
  name = "forgejo-pg-data"
  lifecycle {
    prevent_destroy = true
  }
}

resource "docker_volume" "memos_pg_data" {
  name = "memos-pg-data"
  lifecycle {
    prevent_destroy = true
  }
}

resource "docker_volume" "paperless_pg_data" {
  name = "paperless-pg-data"
  lifecycle {
    prevent_destroy = true
  }
}

resource "docker_volume" "paperless_redis_data" {
  name = "paperless-redis-data"
  lifecycle {
    prevent_destroy = true
  }
}
