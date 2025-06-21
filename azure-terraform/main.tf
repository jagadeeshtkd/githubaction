resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.region
}
resource "azurerm_virtual_network" "spoke_vnet" {
  name                = "${var.prefix}-${var.resource_type_vnet}-${var.app_name}-${var.env}-${var.region}"
  address_space       = ["10.20.0.0/16"]
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_subnet" "spoke_subnet" {
  name                 = "${var.prefix}-subnet-${var.app_name}-${var.env}-${var.region}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  address_prefixes     = ["10.20.1.0/24"]
}
resource "azurerm_network_interface" "nic" {
  name                = "${var.prefix}-nic-${data.external.next_instance.result["next_instance"]}"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.spoke_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_linux_virtual_machine" "vm" {
  count = 2
  name                = "${var.prefix}-${var.resource_type_vm}-${var.app_name}-${var.env}-${var.region}-${data.external.next_instance.result["next_instance"]}"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_B1s"
  admin_username      = "azureuser"

  network_interface_ids = [ azurerm_network_interface.nic.id ]

  admin_password = "StrongPassword123!"  # Replace with SSH in real use
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
data "external" "next_instance" {
  program = ["bash", "${path.module}/get_next_instance.sh"]
}