variable "aws_region" {
  description = "The AWS region where resources will be created."
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "The AWS CLI profile to use for authentication."
  default     = "default"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  description = "CIDR block for the subnet."
  default     = "10.0.1.0/24"
}

variable "subnet_availability_zone" {
  description = "Availability zone for the subnet."
  default     = "us-east-1a"
}

variable "ssh_cidr_blocks" {
  description = "CIDR blocks for SSH access."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "http_cidr_blocks" {
  description = "CIDR blocks for HTTP access."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "https_cidr_blocks" {
  description = "CIDR blocks for HTTPS access."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

