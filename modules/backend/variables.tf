variable "aws_region" {
  description = "The AWS region where resources will be created"
  type        = string
}

variable "private_subnets" {
  description = "List of IDs for private subnets in the VPC"
  type        = list(string)
}

variable "backend_sg" {
  description = "Security group ID for the backend services"
  type        = string
}
