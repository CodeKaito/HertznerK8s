#Define terraform variables
variable "HCLOUD_API_TOKEN" {
  type = string
  sensitive = true
}

variable "SSH_KEY" {
  type = string
  sensitive = true
}

