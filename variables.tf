variable "security_group_name" {
  description = "The name of the security group"
  type        = string
  default     = "nomad-1server-1client-sg-row8"
}

variable "ami" {
  description = "The AMI to run in the cluster"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}

variable "cidrblock" {
    default = "10.0.0.0/20"
    type = string
}
variable "server_instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
  default     = "t2.micro"
}

variable "record_name" {
  description = "dns recored will be add to route53"
  type        = string
}

variable "hosted_zone_name" {
  description = "hosted zone name "
  type        = string
}

variable "email" {
  description = "an email use for lets encrypt "
  type        = string
}
