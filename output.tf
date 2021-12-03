output "private_key" {
  sensitive = true
  value     = tls_private_key.ssh_key.private_key_pem
}

output "public_ip" {
  value = aws_instance.virtual_key.public_ip
}
