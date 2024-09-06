variable "project_name" {
  default = "nginxCustomContent"
}

variable "region" {
  default = "us-east-1"
}

variable "availability_zones" {
  default = ["us-east-1a"]
}

variable "pub_ip" {
  default = "192.168.0.0/24"
}

variable "ami" {
  default = "ami-0c4f7023847b90238"
}

variable "KeyPair" {
  default = "nginx-custom"
}