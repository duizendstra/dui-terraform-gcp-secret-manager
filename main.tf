resource "google_secret_manager_secret" "main" {
  for_each = { for s in var.secrets : s.secret_id => s }

  project   = var.project.project_id
  secret_id = each.value.secret_id

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "main" {
  for_each    = { for s in var.secrets : s.secret_id => s }
  secret      = google_secret_manager_secret.main[each.key].id
  secret_data = each.value.secret_data

  depends_on = [google_secret_manager_secret.main]
}

locals {
  # Flatten the list of members and roles across all secrets
  transformed_secret_accessors = flatten([
    for secret in var.secrets : [
      for member in secret.members : [
        for role in member.roles : {
          secret_id = secret.secret_id
          member    = member.member
          role      = role
        }
      ]
    ]
  ])
}

resource "google_secret_manager_secret_iam_member" "access_secret" {
  for_each = { for member_role in local.transformed_secret_accessors : "${member_role.secret_id}:${member_role.member}:${member_role.role}" => member_role }

  secret_id = google_secret_manager_secret.main[each.value.secret_id].id
  role      = each.value.role
  member    = each.value.member
}
