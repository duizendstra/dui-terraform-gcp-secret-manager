# GCP Secret Manager Terraform Module

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_secret_manager_secret.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret_iam_member.access_secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_secret_manager_secret_version.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project"></a> [project](#input\_project) | The project object containing the project ID and project number. | <pre>object({<br>    project_id       = string<br>    project_services = map(object({}))<br>    service_accounts = optional(map(object({<br>      description    = optional(string)<br>      display_name   = optional(string)<br>      email          = optional(string)<br>      id             = string<br>      member         = string<br>      name           = optional(string)<br>      project_id     = optional(string)<br>      project_number = optional(string)<br>      unique_id      = optional(string)<br>    })))<br>    service_agents = optional(map(object({<br>      email          = optional(string)<br>      id             = string<br>      member         = optional(string)<br>      project_id     = optional(string)<br>      project_number = optional(string)<br>      service        = optional(string)<br>    })))<br>  })</pre> | n/a | yes |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | A list of secrets and their associated IAM members. | <pre>list(object({<br>    secret_id   = string<br>    secret_data = string<br>    members = optional(list(object({<br>      id     = string<br>      member = string<br>      roles  = list(string)<br>    })), []) # Default to an empty list if not provided<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_secrets"></a> [secrets](#output\_secrets) | n/a |
<!-- END_TF_DOCS -->