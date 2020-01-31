output "aks_cluster_subnet_id" {
  value = azurerm_subnet.subnet_aks.id
}

output "aks_cluster_vnet_id" {
  value = azurerm_virtual_network.vnet.id
}