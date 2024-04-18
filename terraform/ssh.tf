resource "hcloud_ssh_key" "SSH_KEY" {
  name       = "SSH_KEY"
  public_key =  var.SSH_KEY
}


