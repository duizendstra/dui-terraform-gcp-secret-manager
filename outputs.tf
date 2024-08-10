output "secret_manager" {
  value = {
    secrets = {
      for secret in var.secrets : secret.secret_id => {
        id      = google_secret_manager_secret.main[secret.secret_id].id
        version = google_secret_manager_secret_version.main[secret.secret_id].id
        iam_members = [
          for iam in local.transformed_iam_members : {
            member = iam.member
            role   = iam.role
          } if iam.secret_id == secret.secret_id
        ]
      }
    }
  }
}
