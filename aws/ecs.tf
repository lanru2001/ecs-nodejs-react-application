#Cloudwatch log group 
resource "aws_cloudwatch_log_group" "feather_log" {
  name              = var.cloudwatch_log_group_name
  retention_in_days = 30
}

#Cloudwatch log stream 
resource "aws_cloudwatch_log_stream" "feather_stream" {
  name           = var.cloudwatch_log_stream 
  log_group_name = aws_cloudwatch_log_group.feather_log.name
}

#ALB security group 
resource "aws_security_group"  "feather_alb" {
  name   = "${var.name}-alb"
  vpc_id = aws_vpc.app_vpc.id
 
  ingress {
   protocol         = "tcp"
   from_port        = 80
   to_port          = 80
   cidr_blocks      = ["0.0.0.0/0"]

  }
 
  ingress {
   protocol         = "tcp"
   from_port        = 443
   to_port          = 443
   cidr_blocks      = ["0.0.0.0/0"]
  
  }

  ingress {
   protocol         = "tcp"
   from_port        = 3000
   to_port          = 3000
   cidr_blocks      = ["0.0.0.0/0"]

  }

  ingress {
   protocol         = "tcp"
   from_port        = 8080
   to_port          = 8080
   cidr_blocks      = ["0.0.0.0/0"]
  }
 
  egress {
   protocol         = "-1"
   from_port        = 0
   to_port          = 0
   cidr_blocks      = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "feather_service" {
  name   = "${var.name}-service"
  vpc_id = aws_vpc.app_vpc.id
	
  ingress {
   protocol         = "tcp"
   from_port        = 80
   to_port          = 80
   cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
   protocol         = "tcp"
   from_port        = 22
   to_port          = 22
   cidr_blocks      = ["0.0.0.0/0"]

  }

  ingress {
   protocol         = "tcp"
   from_port        = 443
   to_port          = 443
   cidr_blocks      = ["0.0.0.0/0"]
  }
 
  ingress {
   protocol         = "tcp"
   from_port        = 8080
   to_port          = 8080
   cidr_blocks      = ["0.0.0.0/0"]
  }

  
  ingress {
   protocol         = "tcp"
   from_port        = 3000
   to_port          = 3000
   cidr_blocks      = ["0.0.0.0/0"]
  }
 
  egress {
   protocol         = "-1"
   from_port        = 0
   to_port          = 0
   cidr_blocks      = ["0.0.0.0/0"]
  }

}

#ALB 
resource "aws_lb" "feather_lb" {
  name               = "${var.name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ aws_security_group.feather_alb.id ]
  subnets            = [ aws_subnet.app_public_subnets[0].id, aws_subnet.app_public_subnets[1].id ]
          
  enable_deletion_protection = false
}

#ALB target group
resource "aws_alb_target_group" "feather_alb_tg_group" {
  name         = "${var.name}-tg"
  port         = 80

  protocol     = "HTTP"
  vpc_id       = aws_vpc.app_vpc.id
  target_type  = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    timeout             = "3"
    path                = var.health_check_path   
    unhealthy_threshold = "2"
  }

  depends_on =  [ aws_lb.feather_lb ]
}

resource "aws_alb_listener" "ecs_alb_http_listner" {
  load_balancer_arn = aws_lb.feather_lb.id
  port              = 80
  protocol          = "HTTP"
  
  depends_on        = [ aws_alb_target_group.feather_alb_tg_group ]
	

  default_action {
     type             = "forward"
     target_group_arn = aws_alb_target_group.feather_alb_tg_group.arn
  }

}

#Update the default listener so that it listens at HTTPS requests on port 443 (as opposed to HTTP on port 80)

# Listener (redirects traffic from the load balancer to the target group)
#resource "aws_alb_listener" "ecs-alb-http-listener" {
#  load_balancer_arn = aws_lb.feather_lb.id
#  port              = "443"
#  protocol          = "HTTPS"
#  ssl_policy        = "ELBSecurityPolicy-2016-08"
#  certificate_arn   = var.certificate_arn
#  depends_on        = [ aws_alb_target_group.feather_alb_tg_group ]
#
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_alb_target_group.feather_alb_tg_group.arn
#  }
#}

#IAM roles for ecs task execution and task role
resource "aws_iam_role"   "ecs_task_execution_role" {
  name = "${var.name}-fargate-role"
 
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy"  "ecs_fargate_policy" {
  name        = "${var.name}-fargate-policy"
  description = "Policy that allows access to ecs fargate task definition"
 
 policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
       {
          "Effect": "Allow",
          "Action": [
              "s3:*",
              "ecs:*",
              "ecr:GetAuthorizationToken",
              "ecr:BatchCheckLayerAvailability",
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "logs:CreateLogStream",
              "logs:PutLogEvents",
              "ssm:GetParameter",
              "ssm:GetParameters",
              "ssm:GetParametersByPath",
              "xray:PutTraceSegments",
              "xray:PutTelemetryRecords",
              "xray:GetSamplingRules",
              "xray:GetSamplingTargets",
              "xray:GetSamplingStatisticSummaries"
          ],
          "Resource": "*"
       },
        {
          "Effect": "Allow",
          "Action": [
            "secretsmanager:GetSecretValue"
          ],
          "Resource": [
            "*"
            
            
          ]
        }
   ]
}
EOF
}
 
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_fargate_policy.arn
}


#Service role and policy 
resource "aws_iam_role"  "feather_svc" {
  name = "${var.name}-svc-role"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
	{
	  "Sid": "",
	  "Effect": "Allow",
	  "Principal": {
		"Service": "ecs.amazonaws.com"
	  },
	  "Action": "sts:AssumeRole"
	}
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "feather_svc_policy" {
  role       = aws_iam_role.feather_svc.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

#ECS Cluster 
resource "aws_ecs_cluster" "feather_cluster" {
  name = "${var.name}-cluster"
}

#ECS Task Definition 
resource "aws_ecs_task_definition" "node_definition" {
  count                    = var.create ? 1:0 
  family                   = "${var.name}-app"
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  requires_compatibilities = ["FARGATE"]
  container_definitions = <<EOF
[
  {
    "image": "${var.docker_image}",
    "name": "${local.environment_prefix}-app",
    "essential": true,
    "cpu": 256,
    "memoryReservation": 512,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80,
        "protocol": "tcp"
      }
    ],
    "mountPoints": [],
    "entryPoint": [],
    "command": [],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "${var.aws_region}",
        "awslogs-group": "${var.cloudwatch_log_group_name}",
        "awslogs-stream-prefix": "${var.cloudwatch_log_stream}"
      }
    },
   
    "placement_constraints": [],
   
    "volume": []
  }
]
EOF
}


#ECS Service 
resource "aws_ecs_service" "app_service" {
  name                               = "${var.name}-service" 
  cluster                            = aws_ecs_cluster.feather_cluster.id
  task_definition                    = aws_ecs_task_definition.node_definition[0].arn
  desired_count                      = 1
  launch_type                        = "FARGATE" 
  scheduling_strategy                = "REPLICA"
  platform_version                   = "LATEST"
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  #health_check_grace_period_seconds  = 60   
  #iam_role                           = aws_iam_role.feather_svc.arn  
  depends_on                         = [ aws_iam_role.feather_svc ] 

  network_configuration {
    security_groups  = [ aws_security_group.feather_alb.id, aws_security_group.feather_service.id ]
    subnets          = [ aws_subnet.app_public_subnets[0].id ,  aws_subnet.app_public_subnets[1].id ]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.feather_alb_tg_group.arn
    container_name   = "${local.environment_prefix}-app"
    container_port   = var.node_container_port
  }
}
