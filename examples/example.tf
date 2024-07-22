terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.38.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 5.38.0"
    }
  }
}

module "secrets" {
  source         = "./.."
  project_id     = "your-project-id"
  project_number = "your-project-number"
  secrets = [
    {
      secret_id   = "your-secret-id"
      secret_data = "your-secret-data"
      accessors = {
        "roles/secretmanager.secretAccessor" = [
          {
            member           = "user@example.com"
            member_type      = "user"
            transform_member = false
            project_id       = ""
            project_number   = ""
          }
        ]
      }
    }
  ]
}