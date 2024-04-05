resource "hcloud_network" "kubernetes-node-network" {
  name     = "kubernetes-node-network"
  ip_range = "172.16.0.0/24"
}

resource "hcloud_network_subnet" "kubernetes-node-subnet" {
  type         = "cloud"
  network_id   = hcloud_network.kubernetes-node-network.id
  network_zone = "eu-central"
  ip_range     = "172.16.0.0/24"
}



