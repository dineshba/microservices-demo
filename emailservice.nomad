"job" "emailservice" {
  "datacenters" = ["dc1"]

  "type" = "service"

  "group" "emailservice" {
    "count" = 1

    "task" "emailservice" {
      "config" = {
        "image" = "dineshba/emailservice"

        "port_map" = {
          "service_port" = 8080
        }
      }

      "driver" = "docker"

      "service" = {
        "name" = "emailservice"

        "port" = "8080"
      }

      "env" = {
        "ENABLE_PROFILER" = "0"

        "PORT" = "8080"
      }
    }
  }
}