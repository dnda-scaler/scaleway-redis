variable "allowed_ips" {
  type=list(string)
}

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