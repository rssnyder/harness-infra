data "azurerm_subscription" "current" {}

data "azurerm_resource_group" "rileysnyderharnessio" {
  name = "rileysnyderharnessio"
}

resource "azurerm_application_security_group" "proxy" {
  name                = "proxy"
  location            = "centralus"
  resource_group_name = data.azurerm_resource_group.rileysnyderharnessio.name
}

resource "azurerm_application_security_group" "web" {
  name                = "web"
  location            = "centralus"
  resource_group_name = data.azurerm_resource_group.rileysnyderharnessio.name
}

resource "azurerm_network_security_group" "web-nsg" {
  name                = "web-nsg"
  location            = "centralus"
  resource_group_name = data.azurerm_resource_group.rileysnyderharnessio.name

  security_rule {
    name                   = "Proxy2222Inbound"
    priority               = 331
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "*"
    source_port_range      = "*"
    source_address_prefix  = "*"
    destination_port_range = "2222"
    destination_application_security_group_ids = [
      azurerm_application_security_group.proxy.id
    ]
  }

  security_rule {
    name                   = "Proxy443Inbound"
    priority               = 321
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "Tcp"
    source_port_range      = "*"
    source_address_prefix  = "*"
    destination_port_range = "443"
    destination_application_security_group_ids = [
      azurerm_application_security_group.proxy.id
    ]
  }

  security_rule {
    name                   = "Proxy80Inbound"
    priority               = 320
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "Tcp"
    source_port_range      = "*"
    source_address_prefix  = "*"
    destination_port_range = "80"
    destination_application_security_group_ids = [
      azurerm_application_security_group.proxy.id
    ]
  }
}

resource "azurerm_virtual_network" "rileysnyderharnessio" {
  name                = "rileysnyderharnessio"
  location            = "centralus"
  resource_group_name = data.azurerm_resource_group.rileysnyderharnessio.name
  address_space       = ["10.0.0.0/16"]
  #   dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "default"
    address_prefix = "10.0.0.0/24"
    # security_group = azurerm_network_security_group.web-nsg.id
  }

  tags = {
    owner = "riley.snyder@harness.io"
  }
}

resource "azurerm_storage_account" "rileysnyderharnessio" {
  name                     = "rileysnyderharnessio"
  resource_group_name      = data.azurerm_resource_group.rileysnyderharnessio.name
  location                 = data.azurerm_resource_group.rileysnyderharnessio.location
  account_tier             = "Standard"
  account_replication_type = "RAGRS"

  tags = {
    ms-resource-usage = "azure-cloud-shell"
    owner             = "riley.snyder@harness.io"
  }
}

resource "azurerm_key_vault" "rileysnyderharnessio" {
  name                        = "rileysnyderharnessio"
  resource_group_name         = data.azurerm_resource_group.rileysnyderharnessio.name
  location                    = "centralus"
  enabled_for_disk_encryption = false
  tenant_id                   = data.azurerm_subscription.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = true
  sku_name                    = "standard"
}

resource "azurerm_container_group" "delegate" {
  name                = "harness-delegate-ng"
  location            = data.azurerm_resource_group.rileysnyderharnessio.location
  resource_group_name = data.azurerm_resource_group.rileysnyderharnessio.name
  ip_address_type     = "None"
  os_type             = "Linux"

  container {
    name   = "delegate"
    image  = "harness/delegate:23.12.81808"
    cpu    = "1"
    memory = "2"

    environment_variables = {
      DELEGATE_NAME             = "aci"
      NEXT_GEN                  = "true"
      DELEGATE_TYPE             = "DOCKER"
      ACCOUNT_ID                = data.harness_current_account.current.id
      LOG_STREAMING_SERVICE_URL = "https://app.harness.io/gratis/log-service/" # change based on your account
      MANAGER_HOST_AND_PORT     = "https://app.harness.io/gratis"              # change based on your account
    }

    secure_environment_variables = {
      DELEGATE_TOKEN = var.delegate_token
    }
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      "78ff246f-45e4-4f96-95e8-6f8549435b26"
    ]
  }
}