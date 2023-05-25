variable "region" {
  description = "aws region to work with"
  type        = string
  default     = ""

}

variable "vpc_name" {
  description = "name of the vpc"
  type        = string
  default     = ""
}

variable "cidr" {
  description = "cidr to use"
  type        = string
  default     = "10.0.0.0/16"
}

# variable "vpc_id" {
#   description = "vpc id to use"
#   type        = string
#   default     = ""
# }

variable "availability_zones" {
  type        = list(string)
  description = "list of availability zones"
  default     = [""]
}


# variable "database_subnet_group_name" {
#   description = "name of the database subnet group"
#   type        = string
#   default     = ""
# }

variable "tags" {
  description = "for resources"
  type        = map(string)
  default     = {}
}

# variable "aws_security_groups" {
#   description = "name of the aws_security_groups"
#   type        = string
#   default     = ""

# }

variable "private_subnets_cidr" {
  type        = list(string)
  description = "list of private subnet cidr"
  default     = ["10.0.128.0/19", "10.0.160.0/19"]
}

variable "public_subnets_cidr" {
  type        = list(string)
  description = "list of public subnet cidr"
  default     = ["10.0.0.0/19", "10.0.32.0/19"]
}

variable "private_subnet_names" {
  type        = list(string)
  description = "list of private subnet names"
  default     = [""]
}

variable "public_subnet_names" {
  type        = list(string)
  description = "list of public subnet names"
  default     = [""]
}

variable "database_subnets_cidr" {
  type        = list(string)
  description = "list of database subnets cidr"
  default     = ["10.0.64.0/20", "10.0.80.0/20"]
}

variable "database_subnet_names" {
  type        = list(string)
  description = "list of database subnet names"
  default     = [""]
}