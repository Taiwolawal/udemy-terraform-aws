provider "aws" {
    region = "us-east-2"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc_cidr_block

  azs             = [var.avail_zone]
  public_subnets  = [var.subnet_cidr_block]
  public_subnet_tags = { Name = "${var.env_prefix}-subnet-1"}

  tags = {
      Name = "${var.env_prefix}-vpc"
  }
} 



module "myapp-server" {
    source = "./modules/webserver"
    vpc_id = module.vpc.vpc_id
    my_ip = var.my_ip
    image_name = var.image_name
    env_prefix = var.env_prefix
    instance_type = var.instance_type
    subnet_id = module.vpc.public_subnets[0]
    avail_zone = var.avail_zone
    public_key = var.public_key 
}



#   user_data = file("entry-script.sh ") 

# connection {
#        type = "ssh"
#        host = self.public_ip
#        user = "ec2-user"
#        private_key = file(var.private_key_location)
#     }

#     provisioner "remote-exec" {
#         # script = file("entry-script.sh")
#         inline = [
#           "export ENV=dev",
#           "mkdir newdir"
#         ]
#     } 

 # provisioner "file" {
    #     source = "entry-script.sh"
    #     destination = "/home/ec2-user/entry-script-on-ec2.sh"
    # }

# resource "aws_route_table" "myapp-route-table" {
#   vpc_id = aws_vpc.myapp-vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.mayapp-gw.id
#   }

#   tags = {
#     Name = "${var.env_prefix}-rtb"
#   }
# }

# resource "aws_route_table_association" "a-rtb-subnet" {
#   subnet_id      = aws_subnet.myapp-subnet-1.id
#   route_table_id = aws_route_table.myapp-route-table.id
# }

 