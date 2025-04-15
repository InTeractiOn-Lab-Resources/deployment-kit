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

variable "public_key_path" {
  description = "Path to your .pub key"
  type        = string
}

variable "private_key_path" {
  description = "Path to your .pem key"
  type        = string
}
