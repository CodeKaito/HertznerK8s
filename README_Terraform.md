### main.tf
```terraform
provider "hcloud" {
 token="${var.HCLOUD_API_TOKEN}"
}
```

```terraform
terraform {
 required_providers {
  hcloud = {
   source = "hetznercloud/hcloud"
    version= "1.36.2"
  }
}
required _version = ">=0.14"
}

provider "hcloud" {
  # Configuration options
  token="${var.HCLOUD_API_TOKEN}"
}

variable "hcloud_token" {
  sensitive = true
}

resource "hcloud_server" "node1" {
  name = "node1"
  image = "debian-11"
  location = "hil"
}
```

### SSH_KEYS
```terraform
#cloud-config
groups:
  - usergroup
users:
  - name: username
    primary_group: usergroup
    groups: sudo
    shell: /bin/bash
    ssh_authorized_keys:
        - your_cool_ssh_public_key
sudo: ALL=(ALL) NOPASSWD:ALL
disable_root: true
ssh_pwauth: false
```

## Run Commands 
```bash
terraform init ## Initialize the terraform
terraform apply ## Start the terraform
{Insert token}
terraform destroy ## Delete all components
```
