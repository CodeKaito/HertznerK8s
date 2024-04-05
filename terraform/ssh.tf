resource "hcloud_ssh_key" "default" {
  name       = "NICK_SSH_KEY"
  public_key =  var.NICK_SSH_KEY
}
