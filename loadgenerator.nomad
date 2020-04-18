"job" "loadgenerator" {
  "datacenters" = ["dc1"]

  "type" = "service"

  "group" "loadgenerator" {
    "count" = 1

    "task" "loadgenerator" {
      "config" = {
        "image" = "dineshba/loadgenerator"
      }

      "driver" = "docker"

      "env" = {
        "FRONTEND_ADDR" = "frontend.service.consul.:80"

        "USERS" = "20"
      }
    }
  }
}