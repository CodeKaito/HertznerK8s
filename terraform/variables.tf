#Define terraform variables
variable "HCLOUD_API_TOKEN" {
  type = string
  sensitive = true
}

variable "EXTERNAL_SSH_KEY" {
  type = string
  sensitive = true
}


