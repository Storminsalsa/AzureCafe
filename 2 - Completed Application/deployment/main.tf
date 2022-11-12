locals {
  sqladminuser = "azurecafeadmin"
  sqladminpwd  = random_password.sqladmin_pwd.result
  suffix       = random_string.service_suffix.result
}

resource "random_string" "service_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "random_password" "sqladmin_pwd" {
  length           = 14
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  min_upper        = 2
  override_special = "_%@"
  special          = true
}

resource "azurerm_resource_group" "azure_cafe" {
  location = var.preferred_location
  name     = var.resource_group_name
}

resource "azurerm_storage_account" "azure_cafe" {
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
  account_tier             = "Standard"
  is_hns_enabled           = "true"
  location                 = azurerm_resource_group.azure_cafe.location
  name                     = "azurecafestorage${local.suffix}"
  resource_group_name      = azurerm_resource_group.azure_cafe.name
}

resource "azurerm_storage_container" "azure_cafe" {
  container_access_type = "blob"
  name                  = "review-photos"
  storage_account_name  = azurerm_storage_account.azure_cafe.name
}

resource "azurerm_mssql_server" "azure_cafe" {
  name                         = "azure-cafe-sql-${local.suffix}"
  location                     = azurerm_resource_group.azure_cafe.location
  resource_group_name          = azurerm_resource_group.azure_cafe.name
  version                      = "12.0"
  administrator_login          = local.sqladminuser
  administrator_login_password = local.sqladminpwd
}

resource "azurerm_mssql_firewall_rule" "azure_cafe" {
  name             = "allow_azuresvcs_to_connect"
  server_id        = azurerm_mssql_server.azure_cafe.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_firewall_rule" "azure_cafe_local_ip" {
  name             = "allow_local_ip"
  server_id        = azurerm_mssql_server.azure_cafe.id
  start_ip_address = var.your_ip_address
  end_ip_address   = var.your_ip_address
}

resource "azurerm_mssql_database" "azure_cafe" {
  name                 = "AzureCafeSqlDatabase"
  server_id            = azurerm_mssql_server.azure_cafe.id
  sku_name             = "Basic"
  collation            = "SQL_Latin1_General_CP1_CI_AS"
  storage_account_type = "Local"
}

resource "azurerm_cognitive_account" "azure_cafe" {
  name                  = "azure-cafe-language-svc-${local.suffix}"
  location              = azurerm_resource_group.azure_cafe.location
  resource_group_name   = azurerm_resource_group.azure_cafe.name
  kind                  = "TextAnalytics"
  sku_name              = "S"
  custom_subdomain_name = "azure-cafe-language-svc-${local.suffix}"
}

resource "azurerm_log_analytics_workspace" "azure_cafe" {
  name                = "azure-cafe-log-analytics-workspace"
  location            = azurerm_resource_group.azure_cafe.location
  resource_group_name = azurerm_resource_group.azure_cafe.name
  sku                 = "PerGB2018"
}

resource "azurerm_application_insights" "azure_cafe" {
  name                = "azure-cafe-application-insights-${local.suffix}"
  location            = azurerm_resource_group.azure_cafe.location
  resource_group_name = azurerm_resource_group.azure_cafe.name
  workspace_id        = azurerm_log_analytics_workspace.azure_cafe.id
  application_type    = "web"
}

resource "azurerm_service_plan" "azure_cafe" {
  name                = "azure-cafe-app-svc-plan"
  location            = azurerm_resource_group.azure_cafe.location
  resource_group_name = azurerm_resource_group.azure_cafe.name
  os_type             = "Windows"
  sku_name            = "S1"
}

resource "azurerm_windows_web_app" "azure_cafe" {
  name                = "azure-cafe-web-${local.suffix}"
  location            = azurerm_resource_group.azure_cafe.location
  resource_group_name = azurerm_resource_group.azure_cafe.name
  service_plan_id     = azurerm_service_plan.azure_cafe.id

  app_settings = {
    "TextAnalyticsKey"                      = azurerm_cognitive_account.azure_cafe.primary_access_key,
    "TextAnalyticsUrl"                      = azurerm_cognitive_account.azure_cafe.endpoint,
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.azure_cafe.connection_string
  }

  connection_string {
    name  = "AzureCafeConnectionString"
    type  = "SQLAzure"
    value = "Server=tcp:${azurerm_mssql_server.azure_cafe.name}.database.windows.net,1433;Initial Catalog=${azurerm_mssql_database.azure_cafe.name};Persist Security Info=False;User ID=${local.sqladminuser};Password=${local.sqladminpwd};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }

  connection_string {
    name  = "StorageConnectionString"
    type  = "Custom"
    value = azurerm_storage_account.azure_cafe.primary_connection_string
  }

  site_config {
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v6.0"
    }
  }
}

output "sql_server_password" {
  value       = local.sqladminpwd
  description = "SQL Server Admin Password"
  sensitive   = true
}