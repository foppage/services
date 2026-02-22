resource "docker_volume" "memos_pg_data" {
  name = "70a05d8204cf139274b6cb27ee3600f111220648d9e0e68f4209cb505c8301fa"

  lifecycle {
    prevent_destroy = true
  }
}

resource "docker_volume" "paperless_pg_data" {
  name = "2f6e226546e56d52150ae41207994c685eed75a285077dadc876a401a24a2e86"
  lifecycle {
    prevent_destroy = true
  }
}

resource "docker_volume" "paperless_redis_data" {
  name = "da6ef86d21b995d6e931844221f9384cafd23b8db9b00c1c7733c1fcff374a42"
  lifecycle {
    prevent_destroy = true
  }
}

resource "docker_volume" "prosody_config" {
  name = "c6977e84bfe7144d5bc780f3bca20cceb1e4301a694f34b8746f5282c467e8b5"
  lifecycle {
    prevent_destroy = true
  }
}