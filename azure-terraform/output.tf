output "vnet_name" {
  value = azurerm_virtual_network.spoke_vnet.name
}

output "vm_name_1" {
  value = azurerm_linux_virtual_machine.vm[0].name
}

output "vm_name_2" {
  value = azurerm_linux_virtual_machine.vm[1].name
}