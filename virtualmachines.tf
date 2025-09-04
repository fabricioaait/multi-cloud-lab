# Azure Linux VMs
resource "azurerm_linux_virtual_machine" "linux_vm" {
  count               = 2
  name                = "linux-vm-${count.index}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.linux_nic[count.index].id
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = count.index == 0 ? data.local_file.azure_linux_vm1_public_key.content : data.local_file.azure_linux_vm2_public_key.content
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}

# Azure Windows VM
resource "azurerm_windows_virtual_machine" "win_vm" {
  name                = "win-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = var.admin_username
  admin_password      = var.admin_win_password
  network_interface_ids = [
    azurerm_network_interface.win_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

### AWS

# Security group SSH
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "SSH allow permission"
  vpc_id      = aws_vpc.main.id # Precisa de uma VPC definida

  ingress {
    description = "SSH do meu IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_public_ip}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

# EC2 AWS
resource "aws_instance" "free_tier_linux" {
  ami                    = var.aws_ami
  instance_type          = var.aws_instance_type
  key_name               = aws_key_pair.aws_key.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  subnet_id              = aws_subnet.main.id # Precisa de uma subnet definida

  tags = {
    Name = "FreeTierLinux"
  }
}

# Elastic IP 
resource "aws_eip" "aws_instance_ip" {
  instance = aws_instance.free_tier_linux.id
}

### GCP 

# GCP Instance
resource "google_compute_instance" "free_tier_linux" {
  name         = "gcp-free-tier-linux"
  machine_type = var.gcp_instance_type
  zone         = var.gcp_zone

  tags = ["ssh-enabled"]

  boot_disk {
    initialize_params {
      image = var.gcp_image
      size  = 30 # GB
    }
  }

  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.subnet.name

    access_config {
      # Ephemeral public IP
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${data.local_file.gcp_linux_vm_public_key.content}"
  }

  service_account {
    scopes = ["cloud-platform"]
  }
}

### Alibaba Cloud

# ECS Instance
resource "alicloud_instance" "free_tier_linux" {
  instance_name   = "alibaba-free-tier-linux"
  instance_type   = var.alibaba_instance_type
  image_id        = var.alibaba_image_id
  vswitch_id      = alicloud_vswitch.main.id
  security_groups = [alicloud_security_group.main.id]

  internet_max_bandwidth_out = 5

  key_name = alicloud_key_pair.main.key_pair_name

  system_disk_category = "cloud_efficiency"
  system_disk_size     = 20

  tags = {
    Name = "FreeTierLinux"
  }
}
