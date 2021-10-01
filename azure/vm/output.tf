output "tls_private_key" { 
    value = tls_private_key.example_ssh.private_key_pem 
    sensitive = true
}

output "instance ip" {
    value = azurerm_linux_virtual_machine.public_ip_address_id
}