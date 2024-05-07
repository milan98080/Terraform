variable "private_subnet_id" {
  type = string
}

variable "bastion_instance_type" {
  type    = string
  default = "t2.micro"
}