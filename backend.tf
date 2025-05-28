terraform {
  backend "http" {
    address        = "https://api.github.com/repos/OWNER/REPO/contents/terraform.tfstate"
    update_method  = "PUT"
    lock_method    = "POST"
    unlock_method  = "DELETE"
    lock_address   = "https://api.github.com/repos/OWNER/REPO/contents/.terraform.tfstate.lock.info"
    unlock_address = "https://api.github.com/repos/OWNER/REPO/contents/.terraform.tfstate.lock.info"
    username       = "x-access-token"
    password       = "GITHUB_TOKEN"
    retry_max      = 3
    retry_wait_min = 5
  }

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}