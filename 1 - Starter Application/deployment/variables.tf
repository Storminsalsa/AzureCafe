variable "preferred_location" {
  description = "Preferred region for deploying services"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "application-insights-azure-cafe"
}

variable "your_ip_address" {
  description = "Your IP address for the SQL Firewall"
  type        = string
}

