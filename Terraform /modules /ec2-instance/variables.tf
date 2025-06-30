variable "ami" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "vpc_id" {}
variable "key_name" {}
variable "user_data" {}
variable "instance_name" {}
variable "disk_size" {
  default = 30
}
variable "security_group_ids" {
  type = list(string)
}
