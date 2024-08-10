module "secret_manager" {
  source = "./.."

  project = {
    project_id = "your-project-id"
    project_services = {
      "secretmanager.googleapis.com" = {}
    }
  }

  secrets = [{
    secret_id   = "your-secret-id"
    secret_data = "your-secret-data"
    members = [
      {
        id     = "your-member-id"
        member = "user:user@example.com"
        roles = [
          "roles/owner"
        ]
      }
    ]
  }]
}