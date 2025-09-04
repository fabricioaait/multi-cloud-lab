### Alibaba Cloud

# VPC Alibaba
resource "alicloud_vpc" "main" {
  vpc_name   = "main-vpc"
  cidr_block = "10.0.0.0/16"  # Primeiro bloco: 10.0.0.0/16
}

# VSwitch Alibaba
resource "alicloud_vswitch" "main" {
  vswitch_name = "main-vswitch"
  vpc_id       = alicloud_vpc.main.id
  cidr_block   = "10.0.1.0/24"
  zone_id      = var.alibaba_zone
}

# Security Group Alibaba
resource "alicloud_security_group" "main" {
  security_group_name = "main-sg"
  vpc_id              = alicloud_vpc.main.id
}

# Security Group rule SSH
resource "alicloud_security_group_rule" "allow_ssh" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = alicloud_security_group.main.id
  cidr_ip           = var.my_public_ip
}

### AWS

# AWS VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.1.0.0/16"  # Segundo bloco: 10.1.0.0/16
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

# AWS Subnet
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "main-subnet"
  }
}

# AWS Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-igw"
  }
}

# AWS Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "main-rt"
  }
}

# AWS Route Table Association
resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# Security group SSH
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "SSH allow permission"
  vpc_id      = aws_vpc.main.id

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

### Azure

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-terraform"
  address_space       = ["10.2.0.0/16"]  # Terceiro bloco: 10.2.0.0/16
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-terraform"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.2.1.0/24"]
}

# Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-terraform"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.my_public_ip
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "RDP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = var.my_public_ip
    destination_address_prefix = "*"
  }
}

# Public IP Linux
resource "azurerm_public_ip" "linux_ip" {
  count               = var.enable_azure ? 2 : 0
  name                = "linux-ip-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Network Interface Linux
resource "azurerm_network_interface" "linux_nic" {
  count               = var.enable_azure ? 2 : 0
  name                = "linux-nic-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linux_ip[count.index].id
  }
}

# NSG Association Linux
resource "azurerm_network_interface_security_group_association" "linux_assoc" {
  count                     = var.enable_azure ? 2 : 0
  network_interface_id      = azurerm_network_interface.linux_nic[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Public IP Windows
resource "azurerm_public_ip" "win_ip" {
  name                = "win-ip"
  count               = var.enable_azure ? 1 : 0
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Network Interface Windows
resource "azurerm_network_interface" "win_nic" {
  count               = var.enable_azure ? 1 : 0
  name                = "win-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.enable_azure ? azurerm_public_ip.win_ip[0].id : null
  }
}

# NSG Association Windows
resource "azurerm_network_interface_security_group_association" "win_assoc" {
  count                     = var.enable_azure ? 1 : 0
  network_interface_id      = azurerm_network_interface.win_nic[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

### GCP

resource "google_compute_network" "vpc" {
  name                    = "gcp-lab-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "gcp-lab-subnet"
  ip_cidr_range = "10.3.1.0/24"  # Quarto bloco: 10.3.0.0/16 (subnet 10.3.1.0/24)
  region        = var.gcp_region
  network       = google_compute_network.vpc.id
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["${var.my_public_ip}"]
  target_tags   = ["ssh-enabled"]
}
