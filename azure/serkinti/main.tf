resource "azurerm_resource_group" "aci_rg" {
  name     = "serkinti-resource-group"
  location = "eastus"
}

provider "azurerm" {
  features {}
}

resource "azurerm_container_group" "containergroup" {
  name                = "serkinti"
  resource_group_name = azurerm_resource_group.aci_rg.name
  location            = azurerm_resource_group.aci_rg.location
  ip_address_type     = "public"
  dns_name_label      = "serkinti"
  os_type             = "Linux"
  restart_policy      = "Never"

  container {
    name   = "api"
    image  = var.image_name
    cpu    = 0.5
    memory = 1.5

    ports {
      port     = 4010
      protocol = "TCP"
    }
  }

  container {
    name   = "ui"
    image  = var.image_name
    cpu    = 0.5
    memory = 1.5

    ports {
      port     = 3023
      protocol = "TCP"
    }

    environment_variables{
      API_URL = "http://localhost:4010"
    }
  }

  tags = {
    "talha" = "altair",
    "serkinti" = "containers"
  }
}

output "containergroup_ip_address" {
  description = "The IP address of the created container group"
  value       = azurerm_container_group.containergroup.ip_address
}

output "containergroup_fqdn" {
  description = "The FQDN of the created container group"
  value       = azurerm_container_group.containergroup.fqdn
}