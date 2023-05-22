# Aws-Network-Topology

## Set up a network topology on AWS (VPC with private &amp; public subnets, IGW, Route tables &amp; NAT)

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







