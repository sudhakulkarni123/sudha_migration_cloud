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

variable "onprem-cidr" {
  description = "cidr to use on prem"
  type        = string
  default     = "11.0.0.0/16"
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

variable "tags" {
  description = "for resources"
  type        = map(string)
  default     = {}
}

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

variable "database_subnet_group_name" {
  type        = string
  description = "database_subnet_group_name"
  default     = ""
}

variable "database_subnet_group" {
  type        = list(string)
  description = "list of database subnets cidr"
  default     = ["subnet-0a031f2fa60d29e72", "subnet-09633b51b70e50357", ]
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
  default     = ["migration-cloud-vpc-database-subnet-1", "migration-cloud-vpc-databse-subnet-2"]
}


variable "db_username" {
  type        = string
  description = "rds database username"
  default     = ""
}

variable "restore_to_point_in_time" {
  description = "nested block: NestingList, min items: 0, max items: 1"
  type = set(object(
    {
      restore_time                  = string
      source_db_instance_identifier = string
      source_dbi_resource_id        = string
      use_latest_restorable_time    = bool
    }
  ))
  default = []
}

variable "ami_id_for_asg" {
  type        = string
  description = "ami for asg"
  default     = ""
}