# Multi-Cloud Architecture

This repository provides a reference architecture for managing multiple cloud providers (Azure, AWS, Google Cloud, and Alibaba Cloud).  

The setup is designed to demonstrate how to organize and secure virtual machines across different cloud environments while maintaining a unified access strategy and cost optimization by taking advantage of free tiers.

---

## 📐 Architecture Overview

<img width="1024" height="1024" alt="image" src="https://github.com/user-attachments/assets/a0311149-ddfc-4cdb-9fcb-c11e0fe0b413" />

The architecture includes:

- **Central Management SSH Keys**  
  - Different SSH access keys for all instances in each cloud environment.  

- **Cloud Providers**
  - Has a On/OFF "button" for Cloud Providers using with variables to enable or not the creation of Infra in one provider. 
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
   terraform plan -var="enable_aws=true" -var="enable_azure=true" -var="enable_gcp=true" -var="enable_alibaba=true"
   ```

4. Deploy the infrastructure:

   ```bash
   terraform apply var="enable_aws=true" -var="enable_azure=true" -var="enable_gcp=true" -var="enable_alibaba=true"
   ```

5. Destroy the infrastructure when finished:

   ```bash
   terraform destroy var="enable_aws=true" -var="enable_azure=true" -var="enable_gcp=true" -var="enable_alibaba=true"
   ```


