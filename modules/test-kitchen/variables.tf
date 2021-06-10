variable "trusted_cidr" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "The list of trusted IP's which will leverage the test kitchen suite."
}

variable "vpc_cidr" {
  type    = string
  default = "192.168.0.0/24"
}
