resource "hcloud_ssh_key" "NICK_SSH_KEY" {
  name       = "NICK_SSH_KEY"
  public_key =  var.NICK_SSH_KEY
}

resource "hcloud_ssh_key" "JERO_SSH_KEY" {
  name       = "JERO_SSH_KEY"
  public_key =  var.JERO_SSH_KEY
}

resource "hcloud_ssh_key" "GABR_SSH_KEY" {
  name       = "GABR_SSH_KEY"
  public_key =  var.GABR_SSH_KEY
}

