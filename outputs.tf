output "secrets" {
  value = {
    for secret in google_secret_manager_secret.main :
    secret.secret_id => {
      id      = secret.id
      version = google_secret_manager_secret_version.main[secret.secret_id].id
    }
  }
}