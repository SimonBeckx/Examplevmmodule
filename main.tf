
resource "azurerm_resource_group" "compute-rg" {
  name = format("%s%s","rg-simon-compute-t-", var.number)
  location = var.location
}

 
resource "azurerm_public_ip" "publicIP" {
name                = format("%s%s","PublicIP-", var.number)
resource_group_name = format("%s%s","rg-simon-compute-t-", var.number)
location            = var.location
allocation_method   = "Dynamic"

depends_on = [
    azurerm_resource_group.compute-rg
    ]
}


resource "azurerm_network_interface" "NIC" {
  name                = format("%s%s","NIC-", var.number)
  location            = var.location
  resource_group_name = format("%s%s","rg-simon-compute-t-", var.number)
  

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicIP.id
  }
}

resource "azurerm_network_interface_security_group_association" "connectSGtoNic" {
  network_interface_id      = azurerm_network_interface.NIC.id
  network_security_group_id = var.network_security_group_id

  depends_on = [
    azurerm_resource_group.compute-rg,
    azurerm_network_interface.NIC
  ]
}

resource "azurerm_windows_virtual_machine" "example" {
  name                     = var.hostname
  resource_group_name      = azurerm_resource_group.compute-rg.name
  location                 = var.location
  size                     = var.intance_type
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.NIC.id,
  ]

  os_disk {
    name                   = "${var.hostname}-osdisk"
    caching                = "ReadWrite"
    storage_account_type   = "Standard_LRS"
    disk_size_gb           = var.OS_disk
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  depends_on = [
     azurerm_resource_group.compute-rg,
     azurerm_network_interface.NIC
   ]
}

resource "azurerm_managed_disk" "managed_disk" {
  for_each = var.data_disks

  name                 = each.value.lun < 10 ? "${var.hostname}-datadisk0${each.value.lun}" : "${var.hostname}-datadisk${each.value.lun}"
  location             = var.location
  resource_group_name  = azurerm_resource_group.compute-rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = each.value.disk_size_gb

  depends_on = [
    azurerm_resource_group.compute-rg
  ]
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk1" {
  for_each = var.data_disks

  managed_disk_id    = azurerm_managed_disk.managed_disk[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.example.id
  lun                = each.value.lun
  caching            = each.value.caching

  depends_on = [
    azurerm_managed_disk.managed_disk,
    azurerm_windows_virtual_machine.example
  ]
}