output "secret_manager" {
  description = "The IAM members and their roles grouped by secret ID"
  value = {
    for id in distinct([for info in local.transformed_iam_members : info.secret_id]) :
    id => {
      id             = id
      email          = lookup([for info in local.transformed_iam_members : info if info.secret_id == id][0], "email", null)
      member         = lookup([for info in local.transformed_iam_members : info if info.secret_id == id][0], "member", null)
      
     resource = {
        member    = [for info in local.transformed_iam_members : google_secret_manager_secret_iam_member.access_secret["${info.secret_id}:${info.member}:${info.role}"].member if info.secret_id == id][0]
        project   = [for info in local.transformed_iam_members : google_secret_manager_secret_iam_member.access_secret["${info.secret_id}:${info.member}:${info.role}"].project if info.secret_id == id][0]
        etag      = [for info in local.transformed_iam_members : google_secret_manager_secret_iam_member.access_secret["${info.secret_id}:${info.member}:${info.role}"].etag if info.secret_id == id][0]
        condition = [for info in local.transformed_iam_members : google_secret_manager_secret_iam_member.access_secret["${info.secret_id}:${info.member}:${info.role}"].condition if info.secret_id == id][0]
                id = [for info in local.transformed_iam_members : google_secret_manager_secret_iam_member.access_secret["${info.secret_id}:${info.member}:${info.role}"].id if info.secret_id == id][0]
                        secret_id = [for info in local.transformed_iam_members : google_secret_manager_secret_iam_member.access_secret["${info.secret_id}:${info.member}:${info.role}"].secret_id if info.secret_id == id][0]
      }

      roles = [
        for info in local.transformed_iam_members : info.role
        if info.secret_id == id
      ]
    }
  }
}

output "project" {
  description = "The project details including project ID and project number."
  value       = var.project
}
