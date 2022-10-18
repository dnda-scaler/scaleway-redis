//ACL does not work for Database attached to a network
resource "scaleway_redis_cluster" "cluster_redis" {
  name = var.db_name
  version = var.redis_version
  node_type = var.node_type
  user_name = var.username
  password = var.password
  tags = [ "test", "redis" ]
  cluster_size = var.cluster_size
  tls_enabled = var.tns_enabled
   private_network {
    id          = "${scaleway_vpc_private_network.pn1.id}"
    service_ips = var.redis_private_ip_cidr
  }
}
