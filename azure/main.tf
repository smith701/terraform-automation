# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=1.28.0"
}

# Create a resource group
resource "azurerm_resource_group" "Dev" {
  name     = "iDare-Dev"
  location = "West Europe"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "Dev" {
  name                = "production-network"
  resource_group_name = "${azurerm_resource_group.Dev.name}"
  location            = "${azurerm_resource_group.Dev.location}"
  address_space       = ["10.0.0.0/16"]
}
################database#####

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_cosmosdb_account" "Dev" {
  name                = "tfex-cosmos-db-${random_integer.ri.result}"
  location            = "${azurerm_resource_group.Dev.location}"
  resource_group_name = "${azurerm_resource_group.Dev.name}"
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  enable_automatic_failover = true

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }

  geo_location {
    location          = "North Europe"
    failover_priority = 1
  }

  geo_location {
    prefix            = "tfex-cosmos-db-${random_integer.ri.result}-customid"
    location          = "${azurerm_resource_group.Dev.location}"
    failover_priority = 0
  }
}
###############################################################
resource "azurerm_app_service_plan" "Dev" {
  name                = "Dev-appserviceplan"
  location            = "${azurerm_resource_group.Dev.location}"
  resource_group_name = "${azurerm_resource_group.Dev.name}"

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "Dev" {
  name                = "iDare-Dev-app-service"
  location            = "${azurerm_resource_group.Dev.location}"
  resource_group_name = "${azurerm_resource_group.Dev.name}"
  app_service_plan_id = "${azurerm_app_service_plan.Dev.id}"

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "Name" = "Dev"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=Dev.mydomain.com;Integrated Security=SSPI"
  }
}

