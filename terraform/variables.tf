#Variables with defaults
variable "aws_region" {
  description = "Aws region for the instance"
  default     = "us-east-2"
}

variable "instance_type" {
  description = "Instance type"
  default     = "t2.micro"
}

variable "public_key_path" {
  description = "Public key file"
  default     = "~/.ssh/server.pub"
}

variable "key_name" {
  description = "Key name"
  default     = "SD-key-terraform1"
}

variable "tags" {
  type = map
  default = {
    ita_group = "Lv-517"
  }
}

variable "min_size" {
  description = "Min size"
  default     = 2
}

variable "max_size" {
  description = "Max size"
  default     = 2
}

variable "min_elb_capacity" {
  description = "Min elb capacity"
  default     = 2
}

variable "infrastructure_version" {
  default = "1"
}
