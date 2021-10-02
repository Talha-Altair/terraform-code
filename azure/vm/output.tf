output "tls_private_key" {
  value     = tls_private_key.example_ssh.private_key_pem
  sensitive = true
}

output "instance_ip" {
  value = azurerm_linux_virtual_machine.myterraformvm.public_ip_address
}

output "ssh_command" {
  value = "ssh -i temp.pem ${azurerm_linux_virtual_machine.myterraformvm.admin_username}@${azurerm_linux_virtual_machine.myterraformvm.public_ip_address}"
}