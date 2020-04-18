"job" "adservice" {
  "datacenters" = ["dc1"]

  "type" = "service"

  "group" "adservice" {
    "count" = 1

    "task" "adservice" {
      "config" = {
        "image" = "dineshba/adservice"

        "port_map" = {
          "service_port" = 9555
        }
      }

      "driver" = "docker"

      "service" = {
        "name" = "adservice"

        "port" = "9555"
      }

      "env" = {
        "PORT" = "9555"
      }
    }
  }
}