#Define terraform variables
variable "HCLOUD_API_TOKEN" {
  type = string
  sensitive = true
}

variable "NICK_SSH_KEY" {
  type = string
  sensitive = true
}

variable "JERO_SSH_KEY" {
  type = string
  sensitive = true
}

variable "GABR_SSH_KEY" {
  type = string
  sensitive = true
}
