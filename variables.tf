variable "project" {
  description = "The project object containing the project ID and project number."
  type = object({
    project_id       = string
    project_services = map(object({}))
  })
  
  validation {
    condition = length(var.project.project_id) >= 6 && length(var.project.project_id) <= 30
    error_message = "The project ID must be between 6 and 30 characters."
  }
  
  validation {
    condition = can(regex("^[a-z][a-z0-9-]*[a-z0-9]$", var.project.project_id))
    error_message = "The project ID can only contain lowercase letters, digits, and hyphens. It must start with a letter and cannot end with a hyphen."
  }

  validation {
    condition = contains(keys(var.project.project_services), "secretmanager.googleapis.com")
    error_message = "The project_services map must include the secretmanager.googleapis.com service."
  }
}

variable "secrets" {
  description = "A list of secrets and their associated IAM members."
  type = list(object({
    secret_id   = string
    secret_data = string
    iam_members = optional(list(object({
      id     = string
      member = string
      roles  = list(string)
    })), []) # Default to an empty list if not provided
  }))
  default = []

  validation {
    condition = alltrue([for config in var.secrets : length(distinct([for member in config.iam_members : member.id])) == length(config.iam_members)])
    error_message = "Each member within the secrets list must have a unique ID."
  }

  validation {
    condition = alltrue([for config in var.secrets : length(distinct([for member in config.iam_members : member.member])) == length(config.iam_members)])
    error_message = "Each member in the iam_members list must be unique."
  }

  validation {
    condition = alltrue([for config in var.secrets : alltrue([for member in config.iam_members : length(distinct(member.roles)) == length(member.roles)])])
    error_message = "Roles within each member's roles list must be unique."
  }
}
