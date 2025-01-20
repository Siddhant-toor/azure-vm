variable "azureRegion" {
  description = "The Azure region where the resources will be created"
}

variable "instanceType" {
  description = "The size of the Azure VM"
}

variable "instanceName" {
  description = "The name of the Azure VM"
}

variable "client_id" {
  type= string
}

variable "subscription_id" {
  type= string
}

variable "client_secret" {
  type= string
}

variable "tenant_id" {
  type= string
}