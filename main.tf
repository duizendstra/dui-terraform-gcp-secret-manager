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

# Create the secrets in Google Secret Manager
resource "google_secret_manager_secret" "main" {
  for_each = { for s in var.secrets : s.secret_id => s }

  project   = var.project.project_id
  secret_id = each.value.secret_id

  replication {
    auto {}
  }
}

# Create secret versions for each secret
resource "google_secret_manager_secret_version" "main" {
  for_each    = { for s in var.secrets : s.secret_id => s }
  secret      = google_secret_manager_secret.main[each.key].id
  secret_data = each.value.secret_data

  # Terraform usually handles dependencies automatically, but this ensures the secret is created first.
  depends_on = [google_secret_manager_secret.main]
}

# Local variable to flatten IAM members across all secrets
locals {
  transformed_iam_members = flatten([
    for secret in var.secrets : [
      for member in secret.iam_members : [
        for role in member.roles : {
          secret_id = secret.secret_id
          email          = split(":", member.member)[1]
          member    = member.member
          role      = role
        }
      ]
    ]
  ])
}

# Assign IAM roles to the secrets based on the flattened IAM members list
resource "google_secret_manager_secret_iam_member" "access_secret" {
  for_each = { for member_role in local.transformed_iam_members : "${member_role.secret_id}:${member_role.member}:${member_role.role}" => member_role }

  secret_id = google_secret_manager_secret.main[each.value.secret_id].id
  role      = each.value.role
  member    = each.value.member
}