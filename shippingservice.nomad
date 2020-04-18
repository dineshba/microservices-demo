"job" "shippingservice" {
  "datacenters" = ["dc1"]

  "type" = "service"

  "group" "shippingservice" {
    "count" = 1

    "task" "shippingservice" {
      "config" = {
        "image" = "dineshba/shippingservice"

        "port_map" = {
          "service_port" = 50051
        }
      }

      "driver" = "docker"

      "service" = {
        "name" = "shippingservice"

        "port" = "50051"
      }

      "env" = {
        "PORT" = "50051"
      }
    }
  }
}