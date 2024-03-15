#Configure Hetzner Cloud Resources 
resource "hcloud_server" "kube-master" {
  name = "kuber-master"
  image = "rocky-9" #da vedere
  server_type = "cx11" 
  datacenter  = "hel1-dc2"
  ssh_keys = [ "EXTERNAL_SSH_KEY" ]

  network {
    network_id = hcloud_network.kubernetes-node-network.id
    ip         = "172.16.0.110"
  }
  
  depends_on = [
    hcloud_network_subnet.kubernetes-node-subnet
  ]

  public_net  {
    ipv4_enabled = true
    ipv6_enabled = false
  }
}

resource "hcloud_server" "kube-worker" {
  count       = 2
  name        = "kube-worker-${count.index + 1}"
  image       = "rocky-9"
  server_type = "cx21"
  datacenter  = "hel1-dc2"
  #ssh_keys    = ["INTERNAL_SSH_KEY"]
  network {
    network_id = hcloud_network.kubernetes-node-network.id
    ip         = "172.16.0.11${count.index + 1}"
  }
}

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

resource "hcloud_ssh_key" "default" {
  name       = "EXTERNAL_SSH_KEY"
  public_key = "${var.EXTERNAL_SSH_KEY}"
}