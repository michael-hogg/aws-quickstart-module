variable "contact" {
  type        = string
  default     = "contact@email.com"
  description = "Contact email for the team who manages the test-kitchen deployment"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment Type"
}

variable "owner" {
  type        = string
  default     = "owner"
  description = "Owner name for the Project"
}

variable "project" {
  type        = string
  default     = "test-kitchen"
  description = "Project title for the tags on resources."
}

variable "trusted_cidr" {
  type = map(object({
    cidr = string
  }))
}

variable "vpc_cidr" {
  type    = string
  default = "192.168.0.0/24"
}
