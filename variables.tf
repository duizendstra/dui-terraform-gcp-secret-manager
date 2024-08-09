variable "project" {
  description = "The project object containing the project ID and project number."
  type = object({
    project_id       = string
    project_services = map(object({}))
    service_accounts = optional(map(object({
      description    = optional(string)
      display_name   = optional(string)
      email          = optional(string)
      id             = string
      member         = string
      name           = optional(string)
      project_id     = optional(string)
      project_number = optional(string)
      unique_id      = optional(string)
    })))
    service_agents = optional(map(object({
      email          = optional(string)
      id             = string
      member         = optional(string)
      project_id     = optional(string)
      project_number = optional(string)
      service        = optional(string)
    })))
  })
  validation {
    condition     = length(var.project.project_id) >= 6 && length(var.project.project_id) <= 30 && can(regex("^[a-z][a-z0-9-]*[a-z0-9]$", var.project.project_id))
    error_message = "The project ID must be between 6 and 30 characters, including the suffix, and can only contain lowercase letters, digits, and hyphens. It must start with a letter and cannot end with a hyphen."
  }

  validation {
    condition = alltrue([
      contains(keys(var.project.project_services), "secretmanager.googleapis.com")
    ])
    error_message = "The project_services map must include the secretmanager.googleapis.com service."
  }
}

variable "secrets" {
  description = "A list of secrets and their associated IAM members."
  type = list(object({
    secret_id   = string
    secret_data = string
    members = optional(list(object({
      id     = string
      member = string
      roles  = list(string)
    })), []) # Default to an empty list if not provided
  }))
  default = []

  validation {
    condition     = alltrue([for config in var.secrets : length(distinct([for member in config.members : member.id])) == length(config.members)])
    error_message = "Each member within the secrets list must have a unique ID."
  }

  validation {
    condition     = alltrue([for config in var.secrets : length(distinct([for member in config.members : member.member])) == length(config.members)])
    error_message = "Each member in the members list must be unique."
  }

  validation {
    condition     = alltrue([for config in var.secrets : alltrue([for member in config.members : length(distinct(member.roles)) == length(member.roles)])])
    error_message = "Roles within each member's roles list must be unique."
  }
}

