### Keys must be generated before and stored on sshkeys/

# Azure Keys
data "local_file" "azure_linux_vm1_public_key" {
  filename = "${path.module}/sshkeys/azure_linux_vm1.pub"
}

data "local_file" "azure_linux_vm2_public_key" {
  filename = "${path.module}/sshkeys/azure_linux_vm2.pub"
}

data "local_file" "azure_windows_vm_public_key" {
  filename = "${path.module}/sshkeys/azure_linux_vm1.pub" # Reutiliza a mesma chave
}

# AWS Keys
data "local_file" "aws_linux_vm_public_key" {
  filename = "${path.module}/sshkeys/aws_linux_vm.pub"
}

resource "aws_key_pair" "aws_key" {
  key_name   = "aws_linux_vm_key"
  public_key = data.local_file.aws_linux_vm_public_key.content
}

# GCP Keys
data "local_file" "gcp_linux_vm_public_key" {
  filename = "${path.module}/sshkeys/gcp_linux_vm.pub"
}

resource "google_compute_project_metadata" "ssh_keys" {
  metadata = {
    ssh-keys = "ubuntu:${data.local_file.gcp_linux_vm_public_key.content}"
  }
}

# Alibaba keys
resource "alicloud_key_pair" "main" {
  key_pair_name = "alibaba_ssh_key"  
  public_key    = file("${path.module}/sshkeys/alibaba_linux_vm.pub")
}
