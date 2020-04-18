"job" "redis-cart" {
  "datacenters" = ["dc1"]

  "type" = "service"

  "group" "redis-cart" {
    "count" = 1

    "task" "redis-cart" {
      "config" = {
        "image" = "dineshba/redis:alpine"
      }

      "driver" = "docker"
    }
  }
}