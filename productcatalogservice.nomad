"job" "productcatalogservice" {
  "datacenters" = ["dc1"]

  "type" = "service"

  "group" "productcatalogservice" {
    "count" = 1

    "task" "productcatalogservice" {
      "config" = {
        "image" = "dineshba/productcatalogservice"

        "port_map" = {
          "service_port" = 3550
        }
      }

      "driver" = "docker"

      "service" = {
        "name" = "productcatalogservice"

        "port" = "3550"
      }

      "env" = {
        "PORT" = "3550"
      }
    }
  }
}