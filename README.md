```terraform
module "Compute_setup_2" {
  source = "git::https://github.com/SimonBeckx/Examplevmmodule.git?ref=v2.0"

  number                       = 2
  hostname                     = "TestVM2"
  subnet_id                    = module.network_setup.subnet_id-1
  network_security_group_id    = module.network_setup.network_security_group_id
  location                     = var.location
  intance_type                 = "Standard_B2s"
  OS_disk                      = 128
  //script_url                   = "https://${module.storage_account_1.storage_account.name}.blob.core.windows.net/${module.storage_account_1.container_name}/${azurerm_storage_blob.script.name}"
  //script_sas                   = data.azurerm_storage_account_sas.example.sas
  //storage_account_name         = module.storage_account_1.storage_account.name
  data_disks                   = {
    datadisk_one = {
      storage_account_type = "Standard_LRS"
      disk_size_gb = 32
      lun = 1
      caching = "ReadWrite"
    }
    # datadisk_two = {
    #   storage_account_type = "Standard_LRS"
    #   disk_size_gb = 32
    #   lun = 2
    #   caching = "ReadWrite"
    # }
  }
  # depends_on = [
  #   azurerm_storage_blob.script
  # ]
}
```
