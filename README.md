# Multi-Cloud Architecture

This repository provides a reference architecture for managing multiple cloud providers (Azure, AWS, Google Cloud, and Alibaba Cloud).  

The setup is designed to demonstrate how to organize and secure virtual machines across different cloud environments while maintaining a unified access strategy and cost optimization by taking advantage of free tiers.

---

## 📐 Architecture Overview

The architecture includes:

- **Central Management SSH Keys**  
  - Different SSH access keys for all instances in each cloud environment.  

- **Cloud Providers**  
  - **Azure**: Two Linux VMs and one Windows VM inside a VNet.  
  - **AWS**: One Linux VM inside a VPC.  
  - **Google Cloud (GCP)**: One Linux VM inside a VPC.  
  - **Alibaba Cloud**: One Linux VM inside a VPC.  

- **Networking & Security**  
  - Each cloud uses its native networking component (VNet for Azure, VPC for AWS/GCP/Alibaba).  
  - Security groups restrict inbound access.  
  - SSH connections are established from the management workstation or public IP to each VM.  

---

## 🛡️ Security Considerations

- Use **key-based SSH authentication** instead of passwords.  
- Restrict SSH access to the management workstation’s IP address.  
- Apply **least privilege** rules in security groups.  

---

## 🚀 How to Use

1. Clone this repository:  
   ```bash
   git clone https://github.com/fabricioaait/multi-cloud-lab.git
   cd multi-cloud-lab
   ````

2. Initialize Terraform:

   ```bash
   terraform init
   ```

3. Preview the deployment plan:

   ```bash
   terraform plan
   ```

4. Deploy the infrastructure:

   ```bash
   terraform apply
   ```

5. Destroy the infrastructure when finished:

   ```bash
   terraform destroy
   ```


