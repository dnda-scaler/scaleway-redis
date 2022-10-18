variable "tns_enabled" {
  type = bool
}
variable "cluster_size" {
  type= number
}
variable "username" {
  type=string
}
variable "password" {
  type=string
}
variable "node_type" {
  type=string
  default = "RED1-MICRO"
}
variable "db_name" {
  type=string
  default ="test_redis"
}

variable "redis_version" {
  type=string
  default ="6.2.6"
}

variable "redis_private_ip_cidr" {
  type=list(string)
  default =["192.168.0.254/24"]
}

variable "subnet_cidr" {
  type=string
  default ="192.168.0.0/24"
}