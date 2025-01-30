provider "azurerm" {
  features {}

}
/*terraform {
  backend "azurerm" {
    resource_group_name  = "example-backend-rg"
    storage_account_name = "examplestorageacct"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }
}*/