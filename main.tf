provider "aws" {
    region = "us-east-2"
}

resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name: "${var.env_prefix}-vpc"
    }
}

module "myapp-subnet" {
    source = "./modules/subnet"
    subnet_cidr_block = var.subnet_cidr_block
    avail_zone = var.avail_zone
    env_prefix = var.env_prefix
    vpc_id = aws_vpc.myapp-vpc.id
    default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
}

module "myapp-server" {
    source = "./modules/webserver"
    vpc_id = aws_vpc.myapp-vpc.id
    my_ip = var.my_ip
    image_name = var.image_name
    env_prefix = var.env_prefix
    instance_type = var.instance_type
    subnet_id = module.myapp-subnet.subnet.id 
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

 