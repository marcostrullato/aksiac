######################################################################### BACKEND
terraform {
  backend "azurerm" {
    key                  = "base.terraform.tfstate"
  }
}

######################################################################### PROVIDERS
provider "azurerm" {
  subscription_id = var.subscription_id
}

######################################################################### DATA
data "terraform_remote_state" "remote_state_core" {
  backend = "azurerm"

  config = {
    tenant_id            = var.tf_backend_tenant_id
    client_id            = var.tf_backend_client_id
    client_secret        = var.tf_backend_client_secret
    subscription_id      = var.tf_backend_subscription_id
    resource_group_name  = var.tf_backend_resource_group_name
    storage_account_name = var.tf_backend_storage_account_name
    container_name       = var.tf_backend_container_name
    key                  = "core.terraform.tfstate"
  }
}


######################################################################### RESOURCES
resource "random_string" "random_string_baseservices_name_suffix" {
  length = 4
  special = false
  upper = false
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet-${terraform.workspace}"
  location            = "${var.region}"
  resource_group_name = data.terraform_remote_state.remote_state_core.outputs.resource_group_name
  address_space       = ["${var.aks_vnet_address_space}"]
}

resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = "${azurerm_virtual_network.vnet.resource_group_name}"
  address_prefix       = "${var.aks_subnet_gpu_address_prefix}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  service_endpoints    = ["Microsoft.ContainerRegistry","Microsoft.AzureCosmosDB","Microsoft.Storage","Microsoft.KeyVault"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  resource_group_name  = "${azurerm_virtual_network.vnet.resource_group_name}"
  address_prefix       = "${var.aks_subnet_address_prefix}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  service_endpoints    = ["Microsoft.ContainerRegistry","Microsoft.AzureCosmosDB","Microsoft.Storage","Microsoft.KeyVault"]
}

resource "azurerm_subnet" "subnet_redis" {
  name                 = "redis-subnet"
  resource_group_name  = "${azurerm_virtual_network.vnet.resource_group_name}"
  address_prefix       = "${var.redis_subnet_address_prefix}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
}
 
resource "azurerm_subnet" "subnet_aci" {
  name                 = "aci-subnet"
  resource_group_name  = "${azurerm_virtual_network.vnet.resource_group_name}"
  address_prefix       = "${var.aci_subnet_address_prefix}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
}

# NOTE: the Name used for Redis needs to be globally unique
resource "azurerm_redis_cache" "redis_cache" {
  name                = "${replace(var.prefix, ".", "-")}redis" # ${random_string.random_string_baseservices_name_suffix.result}
  location            = var.primary_region
  resource_group_name = data.terraform_remote_state.remote_state_core.outputs.resource_group_name
  capacity            = 2
  family              = "P"
  sku_name            = "Premium"
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"
  subnet_id           = azurerm_subnet.subnet_redis.id
  redis_configuration {}
}



resource "azurerm_monitor_diagnostic_setting" "REDIS-LOGS"{
  count                      = "1"
  name                       = "RedisLogAnalytics"
  target_resource_id         = "${azurerm_redis_cache.redis_cache.id}"
  log_analytics_workspace_id = data.terraform_remote_state.remote_state_core.outputs.log_analytics_workspace_id
  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = true
      days = 90
    }
  }
}


resource "azurerm_monitor_diagnostic_setting" "COSMOSDB-LOGS" {
  count                      = "1"
  name                       = "CosmosDBLogAnalytics"
  target_resource_id         = ""
  log_analytics_workspace_id = data.terraform_remote_state.remote_state_core.outputs.log_analytics_workspace_id

  # We need to add the "categories" to log. Each azure resource has a set of categories, for cosmos they are listed here:
  # https://docs.microsoft.com/de-ch/azure/cosmos-db/monitor-cosmos-db-reference
  log {
    category = "DataPlaneRequests"
    enabled  = true

    retention_policy {
      enabled = true
      days = 90
    }
  }
  log {
    category = "MongoRequests"
    enabled  = true

    retention_policy {
      enabled = true
      days = 90
    }
  }
  log {
    category = "QueryRuntimeStatistics"
    enabled  = true

    retention_policy {
      enabled = true
      days = 90
    }
  }
  log {
    category = "PartitionKeyStatistics"
    enabled  = true

    retention_policy {
      enabled = true
      days = 90
    }
  }
  log {
    category = "ControlPlaneRequests"
    enabled  = true

    retention_policy {
      enabled = true
      days = 90
    }
  }
  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = true
      days = 90
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "ACR-LOGS" {
  count                      = "1"
  name                       = "AcrLogAnalytics"
  target_resource_id         = ""
  log_analytics_workspace_id = data.terraform_remote_state.remote_state_core.outputs.log_analytics_workspace_id
  /* log categories found here: https://thorsten-hans.com/azure-container-registry-unleashed-integrate-acr-and-azure-monitor */
  log {
    category = "ContainerRegistryRepositoryEvents"
    enabled  = true

    retention_policy {
      enabled = true
      days = 90
    }
  }
  log {
    category = "ContainerRegistryLoginEvents"
    enabled  = true

    retention_policy {
      enabled = true
      days = 90
    }
  }
  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = true
      days = 90
    }
  }
}
