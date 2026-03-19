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

variable "budget-amount" {
  description = "Budget amount in local currency."
  type        = number
}

variable "budget-thresholds" {
  description = "List of budget thresholds for notifications."
  type        = list(number)
  default     = [50.0, 90.0]
}

variable "budget-alert-mail" {
  description = "Email address to send budget alerts to."
  type        = string
}