variable "resource_group_name" {
type            = string
description     = "name of the resource group"  
default         = "adnoc-terr-rg" 
}
variable "location" {
type            = string
default         = "West Europe" 
}
variable "prefix" {
  default = "RG"
}
/*variable "numberofusers" {
type            = number
default         = 5
description = "This is for no variables"
}
variable "name" {
type = list
description = "list of variables"
default = ["saanvi","sanvit","kiran"]
}
variable "account_name" {
type = map
default = {
    "account1" = "devops1"
    "account2" = "devops2"
    "account3" = "devops3"
    }
  
}*/