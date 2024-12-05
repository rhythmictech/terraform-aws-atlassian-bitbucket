terraform {
  required_version = ">= 0.12.19"

  required_providers {
    aws      = ">= 5"
    random   = ">= 1.2"
    cloudinit = ">= 2.1"
  }
}
