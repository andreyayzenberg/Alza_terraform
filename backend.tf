terraform {
  backend "local" {
    path = "terraform.tfstate"
  }

  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 6.0.0"
    }
  }
}