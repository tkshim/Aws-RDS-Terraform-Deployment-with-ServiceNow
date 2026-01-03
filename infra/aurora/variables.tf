variable "region" {
  type    = string
  default = "ap-northeast-1"
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}
