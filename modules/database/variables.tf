variable "vpc_id" {
  type = string
}

variable "private_subnet_ids_for_cluster" {
  type = list(string)
}

variable "primary_db_subnet_id" {
  type = string
}

variable "replica_db_subnet_id" {
  type = string
}

variable "backend_sg_id" {
  type = string
}


