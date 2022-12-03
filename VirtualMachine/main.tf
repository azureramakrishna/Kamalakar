# Create a New resource group
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

# Create a new virtual network
resource "azurerm_virtual_network" "example" {
  name                = var.virtual_network_name
  address_space       = var.virtual_address_space
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# Create subnets from virtual network
resource "azurerm_subnet" "example" {
  for_each = var.subnets
  name                 = each.value["name"]
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = each.value["address_prefix"]
}

# Create network security group
resource "azurerm_network_security_group" "example" {
  name                = var.network_security_group_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# Create Network security group rules
resource "azurerm_network_security_rule" "testrules" {
  for_each                    = local.nsgrules 
  name                        = each.key
  direction                   = each.value.direction
  access                      = each.value.access
  priority                    = each.value.priority
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.example[id].id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_network_interface" "example" {
  name                = "${var.network_interface_name}-${count.index+1}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  count = var.count_value

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example[id].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "example" {
  name                = "${var.virtual_machine_name}-${count.index+1}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  count               = var.count_value
  size                = var.virtual_machine_size
  admin_username      = var.adminUser
  admin_password      = var.adminPassword
  network_interface_ids = [
    azurerm_network_interface.example[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}