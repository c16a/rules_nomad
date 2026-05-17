job "api" {
  datacenters = ["dc1"]
  type        = "service"

  group "api" {
    count = 1

    network {
      port "http" {
        to = 8080
      }
    }

    service {
      name = "api"
      port = "http"
    }

    task "server" {
      driver = "docker"

      config {
        image = "hashicorp/http-echo:1.0"
        args  = ["-listen", ":8080", "-text", "hello from nomad"]
        ports = ["http"]
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
