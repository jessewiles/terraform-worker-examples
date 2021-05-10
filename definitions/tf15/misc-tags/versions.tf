terraform {
  required_version = ">= 0.13"

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0.0"
    }

    kubectl = {
      source  = "hashicorp/kubectl"
      version = "1.9.4"
    }

  }
}
