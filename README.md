# Public EC2 with Apache and Internet Gateway

## Project Overview
This project provisions an AWS infrastructure using Terraform that deploys an EC2 instance running Apache in a public subnet, enabling direct internet access via an Internet Gateway. Additionally, it provisions a private EC2 instance in a private subnet that accesses the internet through a NAT Gateway. The security group is configured to allow HTTP (80), SSH (22), and HTTPS (443) traffic.

## Architecture Diagram
![Architecture](https://github.com/mohamedesmael10/terraform_aws_apache_vpc/blob/main/Shots/1.png)

## Infrastructure Components
- **VPC**: CIDR block 10.0.0.0/16
- **Public Subnet**: CIDR block 10.0.1.0/24
- **Private Subnet**: CIDR block 10.0.2.0/24
- **Internet Gateway**: Provides internet access to the public subnet
- **NAT Gateway**: Allows the private subnet to access the internet (requires an Elastic IP)
- **Route Tables**: 
  - Public Route Table routes 0.0.0.0/0 traffic to the Internet Gateway.
  - Private Route Table routes 0.0.0.0/0 traffic to the NAT Gateway.
- **Security Groups**: 
  - Apache security group allows inbound HTTP, SSH, and HTTPS traffic.
- **EC2 Instances**:
  - A public instance running Apache with a public IP.
  - A private instance running Apache without a public IP (accesses the internet via the NAT Gateway).
- **Key Pairs**: Automatically generated using Terraform's TLS provider and registered in AWS.

## Prerequisites
- AWS CLI configured with appropriate credentials and permissions.
- Terraform installed (version 0.12+ recommended).

### Deployment Steps
1. **Clone the Repository**
   ```bash
   git clone https://github.com/mohamedesmael10/terraform_aws_apache_vpc.git
   cd terraform_aws_apache_vpc
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Apply the Terraform Configuration**
   ```bash
   terraform apply -auto-approve
   ```
   This command provisions the following resources:
   - VPC with CIDR block 10.0.0.0/16.
   - Public and private subnets.
   - Internet Gateway and NAT Gateway (with an associated Elastic IP).
   - Route Tables for public and private subnets.
   - Security Groups with rules for HTTP, SSH, and HTTPS.
   - Two EC2 instances running Apache.
   - Generated SSH key pairs for instance access.

4. **Access the EC2 Instance**
   - Retrieve the public IP of the public EC2 instance:
     ```bash
     terraform output public_apache_public_ip
     ```
   - Open your browser and navigate to `http://<public-ip>` to view the Apache default page.

## Accessing the Private Instance
Since the private instance does not have a public IP, you can connect to it through the public instance (acting as a bastion host):
1. **SSH into the Public Instance**
   ```bash
   ssh -i path/to/your/private_key.pem ec2-user@<public-ip>
   ```
   Replace `<public-ip>` with the output from Terraform and adjust the username as needed (e.g., `ubuntu` if using Ubuntu).
2. **From the Public Instance, SSH into the Private Instance**
   ```bash
   ssh ec2-user@<private-ip>
   ```
   Replace `<private-ip>` with the private IP of the private EC2 instance. You can obtain this by running:
   ```bash
   terraform output private_apache_private_ip
   ```

## Troubleshooting
If the public EC2 instance is not accessible:
- Verify that the security group allows inbound traffic on port 80.
- Ensure the route table is correctly configured to route 0.0.0.0/0 traffic to the Internet Gateway.
- Check that the Apache service is running on the EC2 instance:
  ```sh
  systemctl status apache2
  ```
- Confirm that the NAT Gateway is properly associated if the private instance is intended to access the internet.

## Cleanup
To destroy all the resources created by Terraform:
```bash
terraform destroy -auto-approve
```

## Screenshots
Below are some screenshots showcasing the project in action:
![Screenshot 2](https://github.com/mohamedesmael10/terraform_aws_apache_vpc/blob/main/Shots/2.png)  
![Screenshot 3](https://github.com/mohamedesmael10/terraform_aws_apache_vpc/blob/main/Shots/3.png)  
![Screenshot 4](https://github.com/mohamedesmael10/terraform_aws_apache_vpc/blob/main/Shots/4.png)  
![Screenshot 5](https://github.com/mohamedesmael10/terraform_aws_apache_vpc/blob/main/Shots/5.png)  
![Screenshot 6](https://github.com/mohamedesmael10/terraform_aws_apache_vpc/blob/main/Shots/6.png)  
![Screenshot 7](https://github.com/mohamedesmael10/terraform_aws_apache_vpc/blob/main/Shots/7.png)  
![Screenshot 8](https://github.com/mohamedesmael10/terraform_aws_apache_vpc/blob/main/Shots/8.png)  
![Screenshot 9](https://github.com/mohamedesmael10/terraform_aws_apache_vpc/blob/main/Shots/9.png)  
![Screenshot 10](https://github.com/mohamedesmael10/terraform_aws_apache_vpc/blob/main/Shots/10.png)

- **Mohamed Mostafa Esmael**  
  Email: [mohamed.mostafa.esmael10@outlook.com](mailto:mohamed.mostafa.esmael10@outlook.com)  
  LinkedIn: [linkedin.com/in/mohamedesmael](https://linkedin.com/in/mohamedesmael)

