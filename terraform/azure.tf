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

  subnet {
    name           = "default"
    address_prefix = "10.0.0.0/24"
  }

  subnet {
    name           = "appgw"
    address_prefix = "10.0.254.0/24"
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
}

resource "azurerm_network_interface" "web" {
  name                = "web-nic"
  location            = "centralus"
  resource_group_name = data.azurerm_resource_group.rileysnyderharnessio.name

  ip_configuration {
    name                          = "config1"
    subnet_id                     = azurerm_virtual_network.rileysnyderharnessio.subnet.*.id[0]
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "web" {
  name                = "web"
  location            = "centralus"
  resource_group_name = data.azurerm_resource_group.rileysnyderharnessio.name
  network_interface_ids = [
    azurerm_network_interface.web.id
  ]
  vm_size = "Standard_A1_v2"

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "web"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "web"
    admin_username = "testadmin"
    admin_password = "Password4321!"
    custom_data    = <<EOF
#!/bin/bash
sudo apt-get update -y &&
sudo apt-get install -y nginx zsh
EOF
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_public_ip" "web" {
  name                = "web"
  resource_group_name = data.azurerm_resource_group.rileysnyderharnessio.name
  location            = "centralus"
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "azurestopping"
}

resource "azurerm_application_gateway" "web" {
  name                = "web"
  resource_group_name = data.azurerm_resource_group.rileysnyderharnessio.name
  location            = "centralus"

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "default"
    subnet_id = azurerm_virtual_network.rileysnyderharnessio.subnet.*.id[1]
  }

  frontend_port {
    name = "frontend"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontend"
    public_ip_address_id = azurerm_public_ip.web.id
  }

  backend_address_pool {
    name = "web"
    ip_addresses = [
      azurerm_network_interface.web.private_ip_address
    ]
  }

  backend_http_settings {
    name                  = "web"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "web"
    frontend_ip_configuration_name = "frontend"
    frontend_port_name             = "frontend"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "web"
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = "web"
    backend_address_pool_name  = "web"
    backend_http_settings_name = "web"
  }

  lifecycle {
    ignore_changes = [
      backend_address_pool,
      backend_http_settings,
      http_listener,
      probe,
      request_routing_rule
    ]
  }
}

resource "harness_autostopping_azure_gateway" "web" {
  name                              = "web"
  cloud_connector_id                = "azuresalesccm"
  host_name                         = "azurestopping.centralus.cloudapp.azure.com"
  region                            = "centralus"
  resource_group                    = data.azurerm_resource_group.rileysnyderharnessio.name
  app_gateway_id                    = azurerm_application_gateway.web.id
  azure_func_region                 = "centralus"
  vpc                               = azurerm_virtual_network.rileysnyderharnessio.id
  delete_cloud_resources_on_destroy = false
}

resource "harness_autostopping_rule_vm" "web" {
  name               = "web"
  cloud_connector_id = "azuresalesccm"
  idle_time_mins     = 5
  filter {
    vm_ids = [
      azurerm_virtual_machine.web.id
    ]
    regions = [
      "centralus"
    ]
  }
  http {
    proxy_id = harness_autostopping_azure_gateway.web.id
    routing {
      source_protocol = "http"
      target_protocol = "http"
      source_port     = 80
      target_port     = 80
      action          = "forward"
    }
    health {
      protocol         = "http"
      port             = 80
      path             = "/"
      timeout          = 30
      status_code_from = 200
      status_code_to   = 399
    }
  }
  custom_domains = [
    "azurestopping.centralus.cloudapp.azure.com"
  ]
}