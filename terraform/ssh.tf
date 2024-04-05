resource "hcloud_ssh_key" "default" {
  name       = "EXTERNAL_SSH_KEY"
  public_key =  var.EXTERNAL_SSH_KEY 
}
