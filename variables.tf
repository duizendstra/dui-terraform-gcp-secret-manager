variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "project_number" {
  description = "The number of the GCP project"
  type        = string
}

variable "secrets" {
  description = "A list of secrets"
  type = list(object({
    secret_id   = string
    secret_data = string
    accessors = optional(map(list(object({
      member           = string
      member_type      = string
      transform_member = bool
      project_id       = string
      project_number   = string
    }))), {})
  }))
  default = []
}






