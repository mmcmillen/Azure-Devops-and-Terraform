terraform {
    required_providers {
      azurerm = {
          source  = "hashicorp/azurerm"
          version = ">=2.26"
      }
    }

    backend "azurerm" {
      resource_group_name  = "rg-terraform-blobstore"
      storage_account_name = "tfstoragemackster"
      container_name       = "tfstate"
      key                  = "terraform.tfstate"
    }
}

provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "rg" {
    name     = "rg-iacdemo"
    location = "westus2"
}

resource "azurerm_container_group" "cg" {
    name                = "weatherapi"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    ip_address_type = "public"
    dns_name_label  = "macksterwa"
    os_type         = "Linux"

    container {
        name   = "weatherapi"
        image  = "mackster/weatherapi"
        cpu    = "1"
        memory = "1"

        ports {
            port     = 80
            protocol = "TCP"
        }
    }
}