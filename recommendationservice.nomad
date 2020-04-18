"job" "recommendationservice" {
  "datacenters" = ["dc1"]

  "type" = "service"

  "group" "recommendationservice" {
    "count" = 1

    "task" "recommendationservice" {
      "config" = {
        "image" = "dineshba/recommendationservice"

        "port_map" = {
          "service_port" = 8080
        }
      }

      "driver" = "docker"

      "service" = {
        "name" = "recommendationservice"

        "port" = "8080"
      }

      "env" = {
        "ENABLE_PROFILER" = "0"

        "PORT" = "8080"

        "PRODUCT_CATALOG_SERVICE_ADDR" = "productcatalogservice.service.consul.:3550"
      }
    }
  }
}