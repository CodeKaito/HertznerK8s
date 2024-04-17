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

  # Esegui lo script bash dopo che il server è pronto
  provisioner "remote-exec" {
    inline = [
      "chmod +x bash.sh", 
      "./bash.sh",   
    ]
  }
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

# # Aggiunta dello snippet per collegare il playbook ansible
# resource "null_resource" "ansible_provisioner" {
#   provisioner "local-exec" {
#     command = "ansible-playbook -i ${join(",", hcloud_server.kube-worker.*.ipv4_address)} playbook_test.yml"
#     working_dir = "${path.module}/ansible"
#   }
# }