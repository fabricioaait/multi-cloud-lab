# Your own public ip or the public ip to ssh to instances
variable "my_public_ip" {
  description = "Public IP to access SSH/RDP"
  type        = string
  default     = "45.175.112.145/32"
}

# Azure
variable "admin_username" {
  description = "Admin username"
  type        = string
  default     = "adminuser"
}

variable "admin_win_password" {
  description = "Admin password for Windows"
  type        = string
  default     = "NovaSenha123!"
  sensitive   = true
}

variable "location" {
  description = "Location of Azure resources"
  type        = string
  default     = "East US"
}

variable "vm_size" {
  description = "Azure VM size"
  type        = string
  default     = "Standard_B1s"
}

# AWS 
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t2.micro"
}

variable "aws_ami" {
  description = "AMI para a instância EC2"
  type        = string
  default     = "ami-00ca32bbc84273381" # Amazon Linux 2
}

### GCP
variable "gcp_region" {
  description = "Região do GCP"
  type        = string
  default     = "us-central1"
}

variable "gcp_zone" {
  description = "Zona do GCP"
  type        = string
  default     = "us-central1-a"
}

variable "gcp_instance_type" {
  description = "Tipo da instância GCP (free tier)"
  type        = string
  default     = "e2-micro" # Free tier eligible
}

variable "gcp_image" {
  description = "Imagem para a instância GCP"
  type        = string
  default     = "ubuntu-2204-lts" # Ubuntu 22.04 LTS
}

# Alibaba Cloud
variable "alibaba_region" {
  description = "Alibaba Cloud Region"
  type        = string
  default     = "ap-southeast-1"
}

variable "alibaba_zone" {
  description = "Alibaba Cloud zone"
  type        = string
  default     = "ap-southeast-1a"
}

variable "alibaba_instance_type" {
  description = "Alibaba cloud ECS Instance size"
  type        = string
  default     = "ecs.t6-c1m1.large"
}

variable "alibaba_image_id" {
  description = "Alibaba cloud ECS Instance image ID"
  type        = string
  default     = "ubuntu_20_04_x64_20G_alibase_20240220.vhd"
}
