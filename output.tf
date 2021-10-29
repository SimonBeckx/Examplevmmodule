output "vm_name" {
  value = azurerm_linux_virtual_machine.example.name
}

output "vm_ip" {
  value = azurerm_linux_virtual_machine.example.source_image_reference
}