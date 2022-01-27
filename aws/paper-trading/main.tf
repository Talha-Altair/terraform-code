provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.deployment_name}-cluster"
}

resource "aws_security_group" "serkinti_sg" {
  name        = "${var.deployment_name}-sg"
  description = "allow inbound access for serkinti ports"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = var.ui_port
    to_port     = var.ui_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = var.api_port
    to_port     = var.api_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_task_definition" "td" {
  family                   = "${var.deployment_name}-td"
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
          containerPort = var.api_port
          hostPort      = var.api_port
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
          containerPort = var.ui_port
          hostPort      = var.ui_port
        }
      ]
      environment = [
        {
          "name" : "API_URL"
          "value" : "http://localhost:${var.api_port}"
        }
      ]
    }
  ])

}

resource "aws_ecs_service" "ecs_service" {
  name             = "${var.deployment_name}-service"
  cluster          = aws_ecs_cluster.cluster.id
  task_definition  = aws_ecs_task_definition.serkinti_td.arn
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "LATEST"
  network_configuration {
    subnets          = [var.subnet_id]
    security_groups  = [aws_security_group.serkinti_sg.id]
    assign_public_ip = true
  }
  lifecycle {
    ignore_changes = [desired_count]
  }

}
