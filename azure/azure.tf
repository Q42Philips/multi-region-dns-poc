# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=2.0.0"
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "zone_printer_example" {
  name     = "zone-printer-example-resources"
  location = "West Europe"
}

resource "azurerm_container_group" "zone_printer_aci_example" {
  name                = "examplecont"
  location            = "${azurerm_resource_group.zone_printer_example.location}"
  resource_group_name = "${azurerm_resource_group.zone_printer_example.name}"
  ip_address_type     = "public"
  dns_name_label      = "examplecont"
  os_type             = "linux"

  container {
    name   = "hw"
    image  = var.image_name
    cpu    = "0.5"
    memory = "1.5"
    port   = "80"
  }

  tags = {
    environment = "testing"
  }
}

# Example used: https://github.com/terraform-providers/terraform-provider-azurerm/blob/master/examples/container-instance/multiple-containers/main.tf