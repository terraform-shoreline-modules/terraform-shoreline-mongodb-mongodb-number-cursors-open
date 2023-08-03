terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "mongodb_number_cursors_open_incident" {
  source    = "./modules/mongodb_number_cursors_open_incident"

  providers = {
    shoreline = shoreline
  }
}