"job" "currencyservice" {
  "datacenters" = ["dc1"]

  "type" = "service"

  "group" "currencyservice" {
    "count" = 1

    "task" "currencyservice" {
      "config" = {
        "image" = "dineshba/currencyservice"

        "port_map" = {
          "service_port" = 7000
        }
      }

      "driver" = "docker"

      "service" = {
        "name" = "currencyservice"

        "port" = "7000"
      }

      "env" = {
        "PORT" = "7000"
      }
    }
  }
}