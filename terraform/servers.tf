#Configure Hetzner Server Cloud Resources 
resource "hcloud_server" "kube-master" {
  name = "kube-master"
  image = "rocky-9" #da vedere
  server_type = "cx11" 
  datacenter  = "hel1-dc2"
  ssh_keys = [ "NICK_SSH_KEY" , "JERO_SSH_KEY" , "GABR_SSH_KEY" ]

  network {
    network_id = hcloud_network.kubernetes-node-network.id
    ip         = "172.16.0.120"
  }

  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }
  
  depends_on = [
    hcloud_network_subnet.kubernetes-node-subnet
  ]

}

resource "hcloud_server" "kube-worker" {
  count       = 2
  name        = "kube-worker-${count.index + 1}"
  image       = "rocky-9"
  server_type = "cx21"
  datacenter  = "hel1-dc2"
  ssh_keys = [ "NICK_SSH_KEY" , "JERO_SSH_KEY" , "GABR_SSH_KEY" ]
  
  network {
    network_id = hcloud_network.kubernetes-node-network.id
    ip         = "172.16.0.12${count.index + 1}"
  }

}