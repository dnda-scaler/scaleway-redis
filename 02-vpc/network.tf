locals {
pn_name="private-network01-svd"
}
# Private Networks 1
resource "scaleway_vpc_private_network" "pn1" {
  name = local.pn_name
}

resource "scaleway_vpc_public_gateway_dhcp" "dhcp_pn1" {
  subnet    = var.subnet_cidr
  dns_local_name =local.pn_name  # if you don't put the dns_local_name here it will be by default equal to priv and wont be aligned with bastion connection
  pool_high = "192.168.0.250"
}
resource "scaleway_vpc_gateway_network" "vcp_gtw_association1" {
  gateway_id         = scaleway_vpc_public_gateway.gw.id
  private_network_id = scaleway_vpc_private_network.pn1.id
  dhcp_id            = scaleway_vpc_public_gateway_dhcp.dhcp_pn1.id
  enable_dhcp        = true
  cleanup_dhcp       = false
  depends_on         = [scaleway_vpc_private_network.pn1]
  
}

# Public Gateway 
resource "scaleway_vpc_public_gateway_ip" "gw_ip" {}

resource "scaleway_vpc_public_gateway" "gw" {
  name  = "public-gateway-svd"
  type  = "VPC-GW-S"
  ip_id = scaleway_vpc_public_gateway_ip.gw_ip.id
  bastion_enabled = true
}


locals {
  private_ip_trim= [for ip in var.redis_private_ip_cidr : trimsuffix(ip,"/24")]
  redis_config= replace(jsonencode({
            redis_host=local.private_ip_trim,
            redis_port="6379",
            redis_username=var.username,
            redis_password=var.password,
            redis_tls_enabled=scaleway_redis_cluster.cluster_redis.tls_enabled,
            redis_cluster_mode=scaleway_redis_cluster.cluster_redis.cluster_size>1
  }),"\"","'")
  redis_client_instance_name= "redis-client"
}
# Instance that will be used to access to the redis server
# redis cli will be install to help that
resource "scaleway_instance_server" "instance" {
  name  = local.redis_client_instance_name
  type  = "DEV1-S"
  image = "ubuntu_focal"
    user_data = {
    cloud-init = <<-EOT
    #cloud-config
    runcmd:
      - curl https://packages.redis.io/gpg | sudo apt-key add -
      - echo "deb https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
      - apt update
      - apt install redis-tools -y
    write_files:
      - content: "${var.tns_enabled?scaleway_redis_cluster.cluster_redis.certificate:"no cert provided"}"
        path: /etc/redis-cli/config/public_certificate.pem
        owner: root:root
        permissions: '0644'
      - content: "${local.redis_config}"
        path: /etc/redis-cli/config/redis_config.json
        owner: root:root
        permissions: '0644'
    EOT
  }
  private_network {
    pn_id = scaleway_vpc_private_network.pn1.id
  }
  depends_on         = [scaleway_vpc_private_network.pn1,scaleway_redis_cluster.cluster_redis]
}