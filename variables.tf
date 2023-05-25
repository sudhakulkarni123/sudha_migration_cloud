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
  default     = ""
}

variable "vpc_id" {
  description = "vpc id to use"
  type        = string
  default     = ""
}

variable "availability_zones" {
  type        = list(string)
  description = "list of availability zones"
  default     = [""]
}


variable "database_subnet_group_name" {
  description = "name of the database subnet group"
  type        = string
  default     = ""
}

variable "tags" {
  description = "for resources"
  type        = map(string)
  default     = {}
}

variable "aws_security_groups" {
  description = "name of the aws_security_groups"
  type        = string
  default     = ""

}

variable "private_subnets_cidr" {
  type        = list(string)
  description = "list of private subnet cidr"
  default     = [""]
}

variable "public_subnets_cidr" {
  type        = list(string)
  description = "list of public subnet cidr"
  default     = [""]
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
  default     = [""]
}

variable "database_subnet_names" {
  type        = list(string)
  description = "list of database subnet names"
  default     = [""]
}