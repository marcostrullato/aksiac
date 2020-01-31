######################################################################### BACKEND
terraform {
  backend "azurerm" {
    key                  = "core.terraform.tfstate"
  }
}

######################################################################### PROVIDER
provider "azurerm" {
  tenant_id = var.tenant_id
  subscription_id = var.subscription_id
}
provider "azuread" {
  tenant_id = var.tenant_id
}

######################################################################### RESOURCES
resource "azurerm_resource_group" "resource_group" {
  name     = "${var.prefix}-rg"
  location = var.region
}

resource "random_string" "random_string_log_analytics_workspace_name_suffix" {
  length = 4
  special = false
  upper = false
}

resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "${var.prefix}-log-analytics-workspace-${random_string.random_string_log_analytics_workspace_name_suffix.result}"
  location            = var.region
  resource_group_name = azurerm_resource_group.resource_group.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azuread_application" "application_aks_cluster" {
  name = "${var.prefix}-aks-cluster"
  type = "native"
}

resource "azuread_service_principal" "service_principal_aks_cluster" {
  application_id = azuread_application.application_aks_cluster.application_id
  # The following tag is required to make the service principal visible under enterprise applications in the portal
  tags = ["WindowsAzureActiveDirectoryIntegratedApp"]
}

resource "random_password" "random_password_application_aks_cluster" {
  length = 16
  special = true

  keepers = {
    azuread_application = azuread_application.application_aks_cluster.application_id
  }
}

resource "azuread_application_password" "application_password_aks_cluster" {
  application_object_id = azuread_application.application_aks_cluster.id
  value = random_password.random_password_application_aks_cluster.result

  end_date = timeadd(timestamp(), "87600h")

  lifecycle {
    ignore_changes = [
      "end_date"]
  }
}


######################################################################### ALL
locals {
  
}
