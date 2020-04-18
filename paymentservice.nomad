"job" "paymentservice" {
  "datacenters" = ["dc1"]

  "type" = "service"

  "group" "paymentservice" {
    "count" = 1

    "task" "paymentservice" {
      "config" = {
        "image" = "dineshba/paymentservice"

        "port_map" = {
          "service_port" = 50051
        }
      }

      "driver" = "docker"

      "service" = {
        "name" = "paymentservice"

        "port" = "50051"
      }

      "env" = {
        "PORT" = "50051"
      }
    }
  }
}