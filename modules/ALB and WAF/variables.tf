variable "alb_security_group_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "alb_subnets" {
  description = "List of subnets where the ALB will be deployed"
  type        = list(string)
}
