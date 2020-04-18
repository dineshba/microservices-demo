"job" "frontend" {
  "datacenters" = ["dc1"]

  "type" = "service"

  "group" "frontend" {
    "count" = 1

    "task" "frontend" {
      "config" = {
        "image" = "dineshba/frontend"

        "port_map" = {
          "service_port" = 8080
        }
      }

      "driver" = "docker"

      "service" = {
        "name" = "frontend"

        "port" = "8080"
      }

      "env" = {
        "AD_SERVICE_ADDR" = "adservice.service.consul.:9555"

        "CART_SERVICE_ADDR" = "cartservice.service.consul.:7070"

        "CHECKOUT_SERVICE_ADDR" = "checkoutservice.service.consul.:5050"

        "CURRENCY_SERVICE_ADDR" = "currencyservice.service.consul.:7000"

        "PORT" = "8080"

        "PRODUCT_CATALOG_SERVICE_ADDR" = "productcatalogservice.service.consul.:3550"

        "RECOMMENDATION_SERVICE_ADDR" = "recommendationservice.service.consul.:8080"

        "SHIPPING_SERVICE_ADDR" = "shippingservice.service.consul.:50051"
      }
    }
  }
}