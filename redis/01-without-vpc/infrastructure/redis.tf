resource "scaleway_redis_cluster" "cluster_redis" {
  name = "test_redis_basic"
  version = "6.2.6"
  node_type = "RED1-MICRO"
  user_name = "root"
  password = "Test1234!&"
  tags = [ "test", "redis" ]
  cluster_size = 3
  //tls_enabled = "true"

  acl {
    ip = "${var.my_other_adress_ip}/32"
    description = "Allow all"
  }
}

