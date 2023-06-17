# Aws-Network-Topology

## Set up a network topology on AWS (VPC with private &amp; public subnets, IGW, Route tables &amp; NAT)

![image](https://github.com/Hannahadora/Aws-Network-Topology/assets/68153712/02addc36-1ee3-48d9-8541-a2a33a6cd95a)

### The Manual HOW-TO

1. Create a VPC: 
   - Go to the AWS Management Console and select VPC from the services menu.
   - Click on "Create VPC" and enter a name, CIDR block, and any other optional details.
   - Click "Create VPC" to create the VPC.

2. Create subnets: 
   - In the VPC dashboard, select "Subnets" from the menu on the left.
   - Click "Create subnet" and enter a name, choose the VPC you created in step 1, and enter a CIDR block.
   - Repeat this step to create both a public subnet and a private subnet.

3. Create an Internet Gateway (IGW):
   - In the VPC dashboard, select "Internet Gateways" from the menu on the left.
   - Click "Create internet gateway" and enter a name.
   - Select the new IGW and click "Attach to VPC" from the "Actions" menu, then choose the VPC you created in step 1.

4. Create a Route Table for the Public Subnet: 
   - In the VPC dashboard, select "Route Tables" from the menu on the left.
   - Click "Create route table" and enter a name.
   - Select the new route table and click on the "Routes" tab.
   - Click "Edit routes" and add a new route with destination 0.0.0.0/0 and target the IGW created in step 3.
   - Associate this route table with the public subnet created in step 2.

5. Create a Route Table for the Private Subnet: 
   - In the VPC dashboard, select "Route Tables" from the menu on the left.
   - Click "Create route table" and enter a name.
   - Select the new route table and click on the "Routes" tab.
   - Click "Edit routes" and add a new route with destination 0.0.0.0/0 and target a new NAT gateway.
   - Associate this route table with the private subnet created in step 2.

6. Create a NAT Gateway:
   - In the VPC dashboard, select "NAT Gateways" from the menu on the left.
   - Click "Create NAT Gateway" and choose the public subnet created in step 2.
   - Choose an existing Elastic IP address or create a new one.

7. Create a Security Group for the NAT Gateway: 
   - In the EC2 dashboard, select "Security Groups" from the menu on the left.
   - Click "Create security group" and enter a name.
   - Add an inbound rule that allows traffic from the private subnet created in step 2.
   - Associate this security group with the NAT gateway created in step 6.


### Creating the VPC resources on aws using a provisioning tool
In this Project, Terraform was used. Visit the network.tf to see how the vpc-hannah-03 was created

### Resources Description
aws_vpc: This resource represents a Virtual Private Cloud (VPC) in AWS. It defines the networking infrastructure for your resources, including subnets, route tables, and security groups.

aws_subnet: This resource defines a subnet within the VPC. Subnets partition the VPC's IP address range and allow you to isolate resources within different availability zones.

aws_internet_gateway: This resource represents an internet gateway, which enables communication between your VPC and the internet. It allows resources within the VPC to access the internet and receive inbound traffic.

aws_route_table: This resource defines a route table, which controls the traffic flow between subnets within the VPC. It specifies the routes and destinations for network traffic.

aws_route: This resource is used to define routes within a route table. It specifies the destination CIDR block and the target (e.g., an internet gateway or a NAT gateway) for traffic routing.

aws_nat_gateway: This resource creates a Network Address Translation (NAT) gateway, which allows resources within private subnets to communicate with the internet while remaining private. It provides outbound internet connectivity for private resources.

aws_eip: This resource creates an Elastic IP (EIP) address, which is a static public IPv4 address that can be associated with an AWS resource. In this case, it is associated with the NAT gateway to provide a consistent public IP address for outbound traffic.

Each resource plays a specific role in defining the network topology and connectivity within your AWS infrastructure. They work together to create a VPC with public and private subnets, establish internet connectivity, and control the flow of traffic between different subnets.


FIG 1: Created with AWS console

![image](https://github.com/Hannahadora/Aws-Network-Topology/assets/68153712/45b13a5c-9ab8-4ddf-a5c4-bf1797ff9efa)


FIG 2: Created with Terraform (IAC)

![image](https://github.com/Hannahadora/Aws-Network-Topology/assets/68153712/4e97acb9-ef34-476e-b844-f8ece3b990ea)







