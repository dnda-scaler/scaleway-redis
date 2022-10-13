terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}

provider "scaleway" {
  zone       = "fr-par-1"
  region     = "fr-par"
  project_id = "8b836bb3-0ffb-4bb7-90bb-8dc01656ccc8"
}