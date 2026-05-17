name        = "production"
description = "Production namespace quota"

limit {
  region = "global"

  region_limit {
    cpu    = 2000
    memory = 4096
  }
}
