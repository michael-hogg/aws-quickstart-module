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
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "Trusted Source IP for inbound communications - recommended to change from default multiple CIDR can be provided."
}

variable "network_cidr" {
  type    = string
  default = "192.168.0.0/24"
}