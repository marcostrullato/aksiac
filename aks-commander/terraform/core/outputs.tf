output "resource_group_name" {
  value = azurerm_resource_group.resource_group.name
}

output "log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.log_analytics_workspace.name
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.log_analytics_workspace.id
}

output "application_aks_cluster_application_id" {
  value = azuread_application.application_aks_cluster.application_id
}

output "random_password_application_aks_cluster_result" {
  value = random_password.random_password_application_aks_cluster.result
}

output "aks_cluster_service_principal_objectId" {
  value = azuread_service_principal.service_principal_aks_cluster.object_id
}

