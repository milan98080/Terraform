variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnets" {
  type = map(object({
    cidr_block = string
    az         = string
    public     = bool
  }))
  default = {
    "public_subnet_1"  = { cidr_block = "10.30.1.0/24", az = "us-east-1a", public = true },
    "public_subnet_2"  = { cidr_block = "10.30.2.0/24", az = "us-east-1b", public = true },
    "public_subnet_3"  = { cidr_block = "10.30.3.0/24", az = "us-east-1c", public = true },
    "private_subnet_1" = { cidr_block = "10.30.1.0/24", az = "us-east-1a", public = false },
    "private_subnet_2" = { cidr_block = "10.30.2.0/24", az = "us-east-1b", public = false },
    "private_subnet_3" = { cidr_block = "10.30.3.0/24", az = "us-east-1c", public = false }
  }
}