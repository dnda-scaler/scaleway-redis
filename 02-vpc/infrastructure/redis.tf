resource "scaleway_redis_cluster" "cluster_redis" {
  name = "test_redis_basic"
  version = "6.2.6"
  node_type = "RED1-MICRO"
  user_name = "root"
  password = "Test1234!&"
  tags = [ "test", "redis" ]
  cluster_size = 1
  tls_enabled = "true" //TLS enabling will requires the TLS key to be downloaded and used on the cli side as only customer key are generated
   private_network {
    id          = "${scaleway_vpc_private_network.pn1.id}"
    service_ips = [
      "192.168.0.254/24" #pool high
    ]
  }
}

resource "scaleway_redis_cluster" "cluster_redis2" {
  name = "test_redis_basic2"
  version = "6.2.6"
  node_type = "RED1-MICRO"
  user_name = "root"
  password = "Test1234!&"
  tags = [ "test", "redis" ]
  cluster_size = 1
  tls_enabled = "true" //TLS enabling will requires the TLS key to be downloaded and used on the cli side as only customer key are generated
  acl {
    description = "Enable access from Loacl Netwxork (NAT)"
    ip = "${scaleway_vpc_public_gateway_ip.gw_ip.address}/32"
  }
}
