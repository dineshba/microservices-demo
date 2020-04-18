"job" "cartservice" {
  "datacenters" = ["dc1"]

  "type" = "service"

  "group" "cartservice" {
    "count" = 1

    "task" "cartservice" {
      "config" = {
        "image" = "dineshba/cartservice"

        "port_map" = {
          "service_port" = 7070
        }
      }

      "driver" = "docker"

      "service" = {
        "name" = "cartservice"

        "port" = "7070"
      }

      "env" = {
        "LISTEN_ADDR" = "0.0.0.0"

        "PORT" = "7070"

        "REDIS_ADDR" = "redis-cart.service.consul.:6379"
      }
    }
  }
}