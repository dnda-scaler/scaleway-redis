locals {
  cert_location="${path.module}/../config/redis_cert.pem"
}

resource "local_file" "redis_config" {
    content  = jsonencode({
            redis_host=scaleway_redis_cluster.cluster_redis.public_network[0].ips,
            redis_port=scaleway_redis_cluster.cluster_redis.public_network[0].port,
            redis_username=var.username,
            redis_password=var.password,
            redis_tls_enabled=scaleway_redis_cluster.cluster_redis.tls_enabled,
            redis_cluster_mode=scaleway_redis_cluster.cluster_redis.cluster_size>1,
            cert_location=local_file.redis_cert.filename
    })
    filename = "../config/default.json"
}

resource "local_file" "redis_cert" {
    content  = scaleway_redis_cluster.cluster_redis.certificate
    filename = local.cert_location
}