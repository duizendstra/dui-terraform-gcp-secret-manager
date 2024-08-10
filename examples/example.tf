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

module "secret_manager" {
  source = "./.."

  # project = {
  #   project_id = "your-project-id"
  #   project_services = {
  #     "secretmanager.googleapis.com" = {}
  #   }
  # }

  project = {
    "project_id" = "dui-module-test-de27"
    "project_services" = {
      "secretmanager.googleapis.com" = {

      }
    }
  }

  secrets = [{
    secret_id   = "your-secret-id"
    secret_data = "your-secret-data"
    iam_members = [
      {
        id     = "your-member-id"
        member = "user:jasper@duizendstra.com"
        roles = [
          "roles/owner"
        ]
      }
    ]
  }]
}

output "secret_manager" {
  description = "The IAM members and their roles"
  value       = module.secret_manager.secret_manager
}