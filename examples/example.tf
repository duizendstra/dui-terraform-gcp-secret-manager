terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.40.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 5.40.0"
    }
  }
}

module "secrets" {
  source = "./.."

  project = {
    project_id = "your-project-id"
    project_services = {
      "secretmanager.googleapis.com" = {
        "disable_on_destroy" = false
      }
    }
  }

  secrets = [{
    secret_id   = "xxx"
    secret_data = "yyy"
    members = [
      {
        id     = "scan-sa"
        member = "user:user@example.com"
        roles = [
          "roles/owner"
        ]
      }
    ]
  }]
}

output "secrets" {
  description = "The IAM members and their roles"
  value       = module.secrets.secrets
}
