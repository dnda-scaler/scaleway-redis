resource "scaleway_redis_cluster" "cluster_redis" {
  name = var.db_name
  version = var.redis_version
  node_type = var.node_type
  user_name = var.username
  password = var.password
  tags = [ "test", "redis" ]
  cluster_size = var.cluster_size
  tls_enabled = var.tns_enabled

  dynamic "acl"{
    for_each = var.allowed_ips
    content{
      ip = "${acl.value}/32"
      description = "Allow IP ${acl.value}/32"
    }
  }
}

