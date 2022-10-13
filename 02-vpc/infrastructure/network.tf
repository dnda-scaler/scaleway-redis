locals {
pn_name="private-network01-svd"
}
# Private Networks 1
resource "scaleway_vpc_private_network" "pn1" {
  name = local.pn_name
}

resource "scaleway_vpc_public_gateway_dhcp" "dhcp_pn1" {
  subnet    = "192.168.0.0/24"
  /*pool_high = "192.168.0.250"
  push_default_route = true*/
  dns_local_name =local.pn_name  # if you don't put the dns_local_name here it will be by default equal to priv and wont be aligned with bastion connection
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

# Instance that will be used to access to the redis server
# redis cli will be install to help that
resource "scaleway_instance_server" "instance" {
  name  = "redis-client"
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
    EOT
  }
  private_network {
    pn_id = scaleway_vpc_private_network.pn1.id
  }
  depends_on         = [scaleway_vpc_private_network.pn1]
}
