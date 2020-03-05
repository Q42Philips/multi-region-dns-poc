output "instance_ips" {
  value = "${azurerm_container_group.zone_printer_aci_example.ip_address}"
}

#the dns fqdn of the container group if dns_name_label is set
output "instance_fqdn" {
  value = "${azurerm_container_group.zone_printer_aci_example.fqdn}"
}
