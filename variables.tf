variable "location" {
  description = "Location to use in azure."
  type        = string
}

variable "name" {
  description = "Name to use in azure."
  type        = string
}

variable "sshpublic-key-path" {
  description = "Path to the public ssh key"
  type        = string
}