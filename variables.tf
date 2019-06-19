variable "project" {
  description = "Project name to use on all resources created (VPC, ALB, etc)"
  type        = string
}

variable "environment" {
  description = "Deploy environment"
  type        = string
  default     = "production"
}

variable "tags" {
  description = "A map of tags to use on all resources"
  type        = map(string)
  default     = {}
}

variable "api_endpoint" {
  description = "Content convert result api endpoint"
  type        = string
}

variable "jwt_secret_key" {
  description = "Check jwt secret key"
  type        = string
}

