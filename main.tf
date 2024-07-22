resource "google_secret_manager_secret" "main" {
  for_each = { for s in var.secrets : s.secret_id => s }

  project   = var.project_id
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
  transformed_secret_accessors = flatten([
    for secret in var.secrets : [
      for role, members in secret.accessors : [
        for member_config in members : {
          secret_id = secret.secret_id
          role      = role
          member = (
            member_config.transform_member && member_config.member_type == "serviceAgent" ?
            "serviceAccount:service-${coalesce(member_config.project_number, var.project_number)}@gcp-sa-${member_config.member}.iam.gserviceaccount.com" :
            member_config.transform_member && member_config.member_type == "serviceAccount" ?
            "serviceAccount:${member_config.member}@${coalesce(member_config.project_id, var.project_id)}.iam.gserviceaccount.com" :
            "${member_config.member_type}:${member_config.member}"
          )
        }
      ]
    ]
  ])
}

resource "google_secret_manager_secret_iam_member" "access_secret" {
  for_each = { for accessor in local.transformed_secret_accessors : "${accessor.secret_id}:${accessor.member}" => accessor }

  secret_id = google_secret_manager_secret.main[each.value.secret_id].id
  role      = each.value.role
  member    = each.value.member
}

