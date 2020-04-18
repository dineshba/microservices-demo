"job" "checkoutservice" {
  "datacenters" = ["dc1"]

  "type" = "service"

  "group" "checkoutservice" {
    "count" = 1

    "task" "checkoutservice" {
      "config" = {
        "image" = "dineshba/checkoutservice"

        "port_map" = {
          "service_port" = 5050
        }
      }

      "driver" = "docker"

      "service" = {
        "name" = "checkoutservice"

        "port" = "5050"
      }

      "env" = {
        "CART_SERVICE_ADDR" = "cartservice.service.consul.:7070"

        "CURRENCY_SERVICE_ADDR" = "currencyservice.service.consul.:7000"

        "EMAIL_SERVICE_ADDR" = "emailservice.service.consul.:8080"

        "PAYMENT_SERVICE_ADDR" = "paymentservice.service.consul.:50051"

        "PORT" = "5050"

        "PRODUCT_CATALOG_SERVICE_ADDR" = "productcatalogservice.service.consul.:3550"

        "SHIPPING_SERVICE_ADDR" = "shippingservice.service.consul.:50051"
      }
    }
  }
}