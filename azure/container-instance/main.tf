resource "azurerm_resource_group" "aci_rg" {
  name     = var.resource_group_name
  location = var.location
}

provider "azurerm" {
  features {}
}


resource "azurerm_container_group" "containergroup" {
  name                = var.container_group_name
  resource_group_name = azurerm_resource_group.aci_rg.name
  location            = azurerm_resource_group.aci_rg.location
  ip_address_type     = "public"
  dns_name_label      = var.dns_name_label
  os_type             = var.os_type
  restart_policy      = "Never"

  container {
    name   = var.container_name
    image  = var.image_name
    cpu    = var.cpu_core_number
    memory = var.memory_size

    ports {
      port     = var.port_number
      protocol = "TCP"
    }
  }

  tags = {
    "talha" = "altair"
  }
}
