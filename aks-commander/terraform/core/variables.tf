### RESOURCE PROVISIONING
variable "tenant_id" {
  type        = string
  description = "The AD subscription in which to provision resources"
}

variable "subscription_id" {
  type        = string
  description = "The Azure subscription in which to provision resources"
}

variable "prefix" {
  type        = string
  description = "Prefix for all the resources provisioned"
}

variable "region" {
  type        = string
  description = "The Azure region in which to provision resources"
}
