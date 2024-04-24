resource "local_file" "ansible_inventory" {
  filename = "../ansible/inventory.yaml"

  content = <<EOT
all:
  hosts:
    kube-master:
      ansible_host: ${hcloud_server.kube-master.ipv4_address}
    kube-worker-1:
      ansible_host: ${hcloud_server.kube-worker[0].ipv4_address}
    kube-worker-2:
      ansible_host: ${hcloud_server.kube-worker[1].ipv4_address}

workers:
  hosts:
    kube-worker-1:
      ansible_host: ${hcloud_server.kube-worker[0].ipv4_address}
    kube-worker-2:
      ansible_host: ${hcloud_server.kube-worker[1].ipv4_address}
EOT
}
