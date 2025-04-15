variable "aws_region" {
  default = "us-east-1"
}

variable "ami_id" {
  description = "Ubuntu 22.04 LTS AMI (Free Tier)"
  default     = "ami-053b0d53c279acc90"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "inline_public_key" {
  description = "Public SSH key inline"
  type        = string
}

variable "public_key_path" {
  description = "Public SSH key path"
  type        = string
}

variable "private_key_path" {
  description = "Private SSH key path"
  type        = string
}