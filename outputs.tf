### Azure Outputs
output "linux_vm_public_ips" {
  description = "Public IPs das Linux VMs"
  value       = [for ip in azurerm_public_ip.linux_ip : ip.ip_address]
}

output "win_vm_public_ip" {
  description = "Public IP da Windows VM"
  value       = azurerm_public_ip.win_ip.ip_address
}

output "my_public_ip" {
  description = "IP público configurado no NSG"
  value       = var.my_public_ip
}

### AWS Outputs
output "aws_instance_public_ip" {
  description = "IP público da instância EC2"
  value       = aws_eip.aws_instance_ip.public_ip
}

output "aws_ssh_connection_command" {
  description = "Comando SSH para conectar à instância AWS"
  value       = "ssh -i sshkeys/aws_linux_vm ec2-user@${aws_eip.aws_instance_ip.public_ip}"
}

### GCP Outputs
output "gcp_instance_public_ip" {
  description = "IP público da instância GCP"
  value       = google_compute_instance.free_tier_linux.network_interface[0].access_config[0].nat_ip
}

output "gcp_ssh_connection_command" {
  description = "Comando SSH para conectar à instância GCP"
  value       = "ssh -i sshkeys/gcp_linux_vm ubuntu@${google_compute_instance.free_tier_linux.network_interface[0].access_config[0].nat_ip}"
}

### SSH Commands
output "azure_linux_vm1_ssh_command" {
  description = "Comando SSH pronto para Azure Linux VM 1"
  value       = "ssh -i sshkeys/azure_linux_vm1 adminuser@${azurerm_public_ip.linux_ip[0].ip_address}"
}

output "azure_linux_vm2_ssh_command" {
  description = "Comando SSH pronto para Azure Linux VM 2"
  value       = "ssh -i sshkeys/azure_linux_vm2 adminuser@${azurerm_public_ip.linux_ip[1].ip_address}"
}

output "aws_linux_vm_ssh_command" {
  description = "Comando SSH pronto para AWS Linux VM"
  value       = "ssh -i sshkeys/aws_linux_vm ec2-user@${aws_eip.aws_instance_ip.public_ip}"
}

output "gcp_linux_vm_ssh_command" {
  description = "Comando SSH pronto para GCP Linux VM"
  value       = "ssh -i sshkeys/gcp_linux_vm ubuntu@${google_compute_instance.free_tier_linux.network_interface[0].access_config[0].nat_ip}"
}

### RDP Windows command
output "azure_windows_rdp_command" {
  description = "Comando RDP para Windows VM (use no cliente RDP)"
  value       = "mstsc /v:${azurerm_public_ip.win_ip.ip_address}"
}

# Alibaba Outputs
output "alibaba_ssh_connection_command" {
  description = "Comando SSH para conectar à instância Alibaba"
  value       = "ssh -i sshkeys/alibaba_linux_vm root@${alicloud_instance.free_tier_linux.public_ip}"
}

### Connections Summary
output "ssh_connection_summary" {
  description = "SSH Connections Summary"
  value       = <<EOT
SSH Commands:

Azure Linux VM 1:  ssh -i sshkeys/azure_linux_vm1 adminuser@${azurerm_public_ip.linux_ip[0].ip_address}
Azure Linux VM 2:  ssh -i sshkeys/azure_linux_vm2 adminuser@${azurerm_public_ip.linux_ip[1].ip_address}
AWS Linux VM:      ssh -i sshkeys/aws_linux_vm ec2-user@${aws_eip.aws_instance_ip.public_ip}
GCP Linux VM:      ssh -i sshkeys/gcp_linux_vm ubuntu@${google_compute_instance.free_tier_linux.network_interface[0].access_config[0].nat_ip}
Alibaba Linux VM:  ssh -i sshkeys/alibaba_linux_vm root@${alicloud_instance.free_tier_linux.public_ip}
Windows RDP:       mstsc /v:${azurerm_public_ip.win_ip.ip_address}
EOT
}
