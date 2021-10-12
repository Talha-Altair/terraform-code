provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_ecs_cluster" "cluster" {
  name = "serkinti-cluster"

  tags = {
    cfteam = "serkinti-terraform"
  }
}

resource "aws_security_group" "serkinti_sg" {
  name        = "serkinti-sg"
  description = "allow inbound access for serkinti ports"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 3023
    to_port     = 3023
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 4010
    to_port     = 4010
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    cfteam = "serkinti-terraform"
  }
}

resource "aws_ecs_task_definition" "serkinti_td" {
  family                   = "serkinti-td"
  task_role_arn            = var.execution_role
  execution_role_arn       = var.execution_role
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  requires_compatibilities = ["FARGATE"]

  container_definitions = jsonencode([
    {
      name      = "backend_container"
      image     = var.api_container
      essential = true
      portMappings = [
        {
          containerPort = 4010
          hostPort      = 4010
        }
      ],
      essential = true
    },
    {
      name      = "frontend_container"
      image     = var.ui_container
      essential = true
      portMappings = [
        {
          containerPort = 3023
          hostPort      = 3023
        }
      ]
      environment = [
        {
          API_URL = "http://localhost:4010"
        }
      ]
    }
  ])

  tags = {
    cfteam = "serkinti-terraform"
  }

}

resource "aws_ecs_service" "ecs_service" {
  name             = "serkint-service"
  cluster          = aws_ecs_cluster.cluster.id
  task_definition  = aws_ecs_task_definition.serkinti_td.arn
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "LATEST"
  network_configuration {
    subnets          = var.subnet_id
    security_groups  = aws_security_group.serkinti_sg.id
    assign_public_ip = true
  }
  lifecycle {
    ignore_changes = [desired_count]
  }

  tags = {
    cfteam = "serkinti-terraform"
  }
}

output "Public_IP" {
  description = "Public_IP of ecs task"
  value       = aws_ecs_service.ecs_service.Public_IP
}
