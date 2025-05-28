terraform {
  backend "http" {
    address        = "https://api.github.com/repos/OWNER/REPO/contents/terraform.tfstate"
    update_method  = "PUT"
    lock_method    = "POST"
    unlock_method  = "DELETE"
    lock_address   = "https://api.github.com/repos/OWNER/REPO/contents/terraform.tfstate.lock"
    unlock_address = "https://api.github.com/repos/OWNER/REPO/contents/terraform.tfstate.lock"
  }

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}