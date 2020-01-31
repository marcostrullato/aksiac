### RESOURCE PROVISIONING
variable "subscription_id" {
  type = string
}

variable "prefix" {
  type = string
}

variable "primary_region" {
  type = string
}
variable "region" {
  type = string
}
variable "tenant_id" {
  type        = string
  description = "The AD subscription in which to provision resources"
}


# Networking
variable "aks_vnet_address_space" {
  type = string
}
variable "aks_subnet_address_prefix" {
  type = string
}

variable "aks_subnet_gpu_address_prefix" {
  type = string
}

variable "redis_subnet_address_prefix" {
  type = string
}
variable "aci_subnet_address_prefix" {
  type = string
}

### TERRAFORM BACKEND
variable "tf_backend_tenant_id" {
  type = string
}
variable "tf_backend_client_id" {
  type = string
}
variable "tf_backend_client_secret" {
  type = string
}
variable "tf_backend_subscription_id" {
  type = string
}
variable "tf_backend_resource_group_name" {
  type = string
}
variable "tf_backend_storage_account_name" {
  type = string
}
variable "tf_backend_container_name" {
  type = string
}
