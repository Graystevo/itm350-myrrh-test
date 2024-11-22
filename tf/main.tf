data "template_file" "user_data" {
  template = <<-EOT
   #! /bin/bash
   echo "ECS_CLUSTER=${var.cluster_name}" >> /etc/ecs/ecs.config
 EOT
}

resource "aws_vpc" "ecs-vpc" {
 cidr_block           = var.vpc_cidr
 enable_dns_hostnames = true
 tags = {
   Name = var.vpc_prefix 
 }
}

resource "aws_subnet" "subnet-pub1" {
 vpc_id                  = aws_vpc.ecs-vpc.id
 cidr_block              = cidrsubnet(aws_vpc.ecs-vpc.cidr_block, 8, 1)
 map_public_ip_on_launch = true
 availability_zone       = "${var.region}a"
 tags = {
   Name = "${var.vpc_prefix}-public-2a"
 }

}

resource "aws_subnet" "subnet-pub2" {
 TODO:
 vpc_id                  = aws_vpc.ecs-vpc.id
 cidr_block              = cidrsubnet(aws_vpc.ecs-vpc.cidr_block, 8, 2)
 map_public_ip_on_launch = true
 availability_zone       = "${var.region}b"
 tags = {
   Name = "${var.vpc_prefix}-public-2b"
 }

}

resource "aws_subnet" "subnet-priv1" {
 vpc_id                  = aws_vpc.ecs-vpc.id
 cidr_block              = cidrsubnet(aws_vpc.ecs-vpc.cidr_block, 8, 3)
 map_public_ip_on_launch = false
 availability_zone       = "${var.region}a"
 tags = {
   Name = "${var.vpc_prefix}-private-2a"
 }

}

resource "aws_subnet" "subnet-priv2" {
 TODO:
 vpc_id                  = aws_vpc.ecs-vpc.id
 cidr_block              = cidrsubnet(aws_vpc.ecs-vpc.cidr_block, 8, 4)
 map_public_ip_on_launch = true
 availability_zone       = "${var.region}b"
 tags = {
   Name = "${var.vpc_prefix}-private-2b"
 }

}

resource "aws_internet_gateway" "internet_gateway" {
 TODO:
  vpc_id = aws_vpc.ecs-vpc.id
  tags = {
   Name = "internet_gateway"
 }

}

resource "aws_eip" "nat_gateway" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  TODO:
  vpc_id = aws_vpc.ecs-vpc.id
  tags = {
    Name = "NAT_gw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_route_table" "route_table" {
TODO:
  vpc_id = aws_vpc.ecs-vpc.id
  route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.internet_gateway.id
 }

}

resource "aws_route_table" "private_route_table" {
TODO:
  vpc_id = aws_vpc.ecs-vpc.id
  route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_nat_gateway.NAT_gw.id
 }

}

resource "aws_route_table_association" "subnet_route" {
 subnet_id      = aws_subnet.subnet-pub1.id
 route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "subnet2_route" {
TODO:
 subnet_id      = aws_subnet.subnet-pub2.id
 route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "priv_subnet1_route" {
TODO:
 subnet_id      = aws_subnet.subnet-priv1.id
 route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "priv_subnet2_route" {
TODO:
 subnet_id      = aws_subnet.subnet-priv2.id
 route_table_id = aws_route_table.private_route_table.id
}

resource "aws_security_group" "alb-http-sg" {
TODO:
  ingress {
   from_port   = 0
   to_port     = 0
   protocol    = -1
   self        = "false"
   cidr_blocks = ["0.0.0.0/0"]
   description = "any"
 }

 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
  tags = {
   Name = "alb-http-sg"
   vpc_id = aws_vpc.ecs-vpc.id
 }
}

resource "aws_security_group" "ecs-cluster-sg" {
TODO:
  ingress {
	    from_port   = 32153 
	    to_port     = 65535
	    protocol    = "tcp"
	    security_groups = ["${aws_security_group.alb-http-sg.id}"]
	}
  ingress {
            from_port   = 22
            to_port     = 22
            protocol    = "tcp"
            security_groups = ["${aws_security_group.alb-http-sg.id}"]
        }

  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
	}
 tags = {
   Name = "ecs-cluster-sg"
   vpc_id = aws_vpc.ecs-vpc.id
 }
}

resource "aws_key_pair" "ecs-node-kp" {
  key_name   = "ecs-node-key"
  public_key = "AAAAB3NzaC1yc2EAAAADAQABAAABAQC4O8qz/9ek5nRYj5GRhn5NR1OXyHK5FEpM
XLboIdtubEwkYHMJekO4NI6kdg3Nwu0hxqK714z5uNcu7OKgHBU5LK7euro6yboX
tJ33YNK4UzVN47qpI0p+Xzz/q0GA/b2h3DHbEl85QBa7VpbKxfYvlfAoVZwC1kPf
1d65rGdLW63Jro6QE5CH/0PcCyTwzHh9vV008Ub1OldwZP117L/ym7dCTJeTJt65
HT8EW9nC3EZn+etdIRgztLwm21H1VagBCf5Z3OwUXHMyGGR3z64BiEhJVTmp1cbc
0wHTLlny55A1RygR4merWl3Wim9hacCERSTQ2Jx5rfy9bdTx5U5D"
}

resource "aws_launch_template" "ecs_lt" {
 name_prefix   = "ecs-template"
 image_id      = var.ami
 instance_type = var.instance_type
 key_name               = aws_key_pair.ecs-node-kp.key_name
 vpc_security_group_ids = [aws_security_group.ecs-cluster-sg.id]
 iam_instance_profile {
   name = "LabInstanceProfile"
 }
 block_device_mappings {
   device_name = "/dev/xvda"
   ebs {
     volume_size = 30
     volume_type = "gp2"
   }
 }
 tag_specifications {
   resource_type = "instance"
   tags = {
     Name = "${var.instance_name_prefix}"
   }
 }
 user_data = "${base64encode(data.template_file.user_data.rendered)}"
}

resource "aws_autoscaling_group" "ecs_asg" {
 vpc_zone_identifier = [aws_subnet.subnet-priv1.id, aws_subnet.subnet-priv2.id]
TODO:

 desired_capacity    = 2
 max_size            = 3
 min_size            = 1

 launch_template {
   id      = aws_launch_template.ecs_lt.id
   version = "$Latest"
 }

 tag {
   key                 = "AmazonECSManaged"
   value               = true
   propagate_at_launch = true
 }
}

resource "aws_lb" "ecs_alb" {
TODO:
 name               = "ecs-alb"
 internal           = false
 load_balancer_type = "application"
 security_groups    = [aws_security_group.alb-http-sg.id]
 subnets            = [aws_subnet.subnet-pub1.id, aws_subnet.subnet-pub2.id]

 tags = {
   Name = "ecs-alb"
 }
}

resource "aws_lb_listener" "ecs_alb_listener" {
TODO:
 load_balancer_arn = aws_lb.ecs_alb.arn
 port              = 80
 protocol          = "HTTP"

 default_action {
   type             = "forward"
   target_group_arn = aws_lb_target_group.ecs_tg.arn
 }
}

resource "aws_lb_target_group" "ecs_tg" {
 name        = "ecs-target-group"
 port        = 80
 protocol    = "HTTP"
 target_type = "instance"
 vpc_id      = aws_vpc.ecs-vpc.id

 health_check {
   path = "/"
 }
}

resource "aws_ecs_cluster" "ecs_cluster" {
 name = var.cluster_name
}

resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
TODO:
 name = "test1"

  auto_scaling_group_provider {
   auto_scaling_group_arn = aws_autoscaling_group.ecs_asg.arn

   managed_scaling {
     maximum_scaling_step_size = 1000
     minimum_scaling_step_size = 1
     status                    = "ENABLED"
     target_capacity           = 3
   }
 }
}

resource "aws_ecs_cluster_capacity_providers" "cluster-cp" {
 cluster_name = aws_ecs_cluster.ecs_cluster.name

 capacity_providers = [aws_ecs_capacity_provider.ecs_capacity_provider.name]

 default_capacity_provider_strategy {
   base              = 1
   weight            = 100
   capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
 }
}

resource "aws_ecs_task_definition" "bb_task_definition" {
 family             = "bb-task"
 network_mode       = "bridge"
 execution_role_arn = var.lab_role
 task_role_arn      = var.lab_role
 cpu                = 256
 memory             = 256
 runtime_platform {
   operating_system_family = "LINUX"
   cpu_architecture        = "X86_64"
 }
 container_definitions = jsonencode([
   {
     name      = "bb"
     image     = var.container_image
     cpu       = 0
     essential = true
     portMappings = [
       {
         containerPort = var.container_port
         hostPort      = 0
         protocol      = "tcp"
         appProtocol   = "http"
       }
     ]
   }
 ])
}

resource "aws_ecs_service" "ecs_service" {
 name            = "bb-ecs-srv"
 cluster         = aws_ecs_cluster.ecs_cluster.id
 task_definition = aws_ecs_task_definition.bb_task_definition.arn
 desired_count   = 2
 force_new_deployment = true
 placement_constraints {
   type = "distinctInstance"
 }

 triggers = {
   redeployment = timestamp()
 }

 capacity_provider_strategy {
   capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
   weight            = 100
 }

 load_balancer {
   target_group_arn = aws_lb_target_group.ecs_tg.arn
   container_name   = "bb"
   container_port   = var.container_port
 }

 depends_on = [aws_autoscaling_group.ecs_asg]
}
