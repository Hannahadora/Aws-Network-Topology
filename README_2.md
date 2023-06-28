# Provisioning  a Highly Available Web Server on AWS With ASG and ALB

## Step-by-Step Guide USING AWS Management console

![image](https://github.com/Hannahadora/Aws-Network-Topology/assets/68153712/3b7283b6-fb5a-4e6f-8d1a-139e2c86477f)


### The Manual HOW-TO

1. Set up the VPC:
  - Refer to README.md for guidelines on how to set up the AWS network infrastructure which includes the VPC, Subnets etc

2. Configure Security Groups
  - In the EC2 dashboard, Find the “Network & Security” section and click on “Security Groups” to access the Security Groups page.
  - click on the “Create Security Group” button to start creating a new security group.
  - Create two security groups: one for the ASG and one for the ALB.
  - For the ASG security group, add an inbound rule to allow traffic from the ALB security group. Set the source as the ALB security group.
  - For the ALB security group, add inbound rules to allow all traffic on ports 80 and 443.

3. Create the ALB and the target group by following the wizard on the AWS management console
3. Create the ASG and the launch template by following the wizard on the AWS management console


### Creating the VPC resources on AWS using a provisioning tool
In this Project, Terraform was used. Visit the network.tf to see how the vpc-hannah-03 was created

### Resources Description
aws_alb: An Application Load Balancer (ALB) helps in distributing incoming traffic across multiple EC2 instances.

aws_asg: Auto Scaling Group is a feature in AWS that automatically adjusts (scaling up and down) the number of EC2 instances based on demands. 

FIF 1: Created with AWs MANAGEMENT CONSOLE
![image](https://github.com/Hannahadora/Aws-Network-Topology/assets/68153712/99155596-6b8b-44c2-baa1-4747c5612fbb)

DNS NAME: http://sample-alb-823057683.us-east-1.elb.amazonaws.com

FIG 2: Created with Terraform (IAC)

![WhatsApp Image 2023-06-25 at 00 22 04](https://github.com/Hannahadora/Aws-Network-Topology/assets/68153712/2e706529-91c6-40af-be31-c8111beb2785)

DNS NAME: http://sample-alb-823057683.us-east-1.elb.amazonaws.com




