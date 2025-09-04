### Azure Outputs
output "linux_vm_public_ips" {
  description = "Public IPs das Linux VMs"
  value       = var.enable_azure ? [for ip in azurerm_public_ip.linux_ip : ip.ip_address] : []
}

output "win_vm_public_ip" {
  description = "Public IP da Windows VM"
  value       = var.enable_azure ? azurerm_public_ip.win_ip[0].ip_address : null
}

### AWS Outputs
output "aws_instance_public_ip" {
  description = "IP público da instância EC2"
  value       = var.enable_aws ? aws_eip.aws_instance_ip[0].public_ip : null
}

output "aws_ssh_connection_command" {
  description = "Comando SSH para conectar à instância AWS"
  value       = var.enable_aws ? "ssh -i sshkeys/aws_linux_vm ec2-user@${aws_eip.aws_instance_ip[0].public_ip}" : null
}

### GCP Outputs
output "gcp_instance_public_ip" {
  description = "IP público da instância GCP"
  value       = var.enable_gcp ? google_compute_instance.free_tier_linux[0].network_interface[0].access_config[0].nat_ip : null
}

output "gcp_ssh_connection_command" {
  description = "Comando SSH para conectar à instância GCP"
  value       = var.enable_gcp ? "ssh -i sshkeys/gcp_linux_vm ubuntu@${google_compute_instance.free_tier_linux[0].network_interface[0].access_config[0].nat_ip}" : null
}

### SSH Commands
output "azure_linux_vm1_ssh_command" {
  description = "Comando SSH pronto para Azure Linux VM 1"
  value       = var.enable_azure ? "ssh -i sshkeys/azure_linux_vm1 adminuser@${azurerm_public_ip.linux_ip[0].ip_address}" : null
}

output "azure_linux_vm2_ssh_command" {
  description = "Comando SSH pronto para Azure Linux VM 2"
  value       = var.enable_azure ? "ssh -i sshkeys/azure_linux_vm2 adminuser@${azurerm_public_ip.linux_ip[1].ip_address}" : null
}

output "aws_linux_vm_ssh_command" {
  description = "Comando SSH pronto para AWS Linux VM"
  value       = var.enable_aws ? "ssh -i sshkeys/aws_linux_vm ec2-user@${aws_eip.aws_instance_ip[0].public_ip}" : null
}

output "gcp_linux_vm_ssh_command" {
  description = "Comando SSH pronto para GCP Linux VM"
  value       = var.enable_gcp ? "ssh -i sshkeys/gcp_linux_vm ubuntu@${google_compute_instance.free_tier_linux[0].network_interface[0].access_config[0].nat_ip}" : null
}

### RDP Windows command
output "azure_windows_rdp_command" {
  description = "Comando RDP para Windows VM (use no cliente RDP)"
  value       = var.enable_azure ? "mstsc /v:${azurerm_public_ip.win_ip[0].ip_address}" : null
}

# Alibaba Outputs
output "alibaba_ssh_connection_command" {
  description = "Comando SSH para conectar à instância Alibaba"
  value       = var.enable_alibaba ? "ssh -i sshkeys/alibaba_linux_vm root@${alicloud_instance.free_tier_linux[0].public_ip}" : null
}

### Connections Summary
output "ssh_connection_summary" {
  description = "SSH Connections Summary"
  value       = <<EOT
SSH Commands:

${var.enable_azure ? "Azure Linux VM 1:  ssh -i sshkeys/azure_linux_vm1 adminuser@${azurerm_public_ip.linux_ip[0].ip_address}\nAzure Linux VM 2:  ssh -i sshkeys/azure_linux_vm2 adminuser@${azurerm_public_ip.linux_ip[1].ip_address}\nWindows RDP:       mstsc /v:${azurerm_public_ip.win_ip[0].ip_address}\n" : ""}${var.enable_aws ? "AWS Linux VM:      ssh -i sshkeys/aws_linux_vm ec2-user@${aws_eip.aws_instance_ip[0].public_ip}\n" : ""}${var.enable_gcp ? "GCP Linux VM:      ssh -i sshkeys/gcp_linux_vm ubuntu@${google_compute_instance.free_tier_linux[0].network_interface[0].access_config[0].nat_ip}\n" : ""}${var.enable_alibaba ? "Alibaba Linux VM:  ssh -i sshkeys/alibaba_linux_vm root@${alicloud_instance.free_tier_linux[0].public_ip}\n" : ""}
EOT
}
