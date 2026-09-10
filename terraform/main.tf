provider "aws" {
  region = "us-east-1"
}

# -----------------------------
# ECS Cluster
# -----------------------------
resource "aws_ecs_cluster" "main" {
  name = "swarali-cluster-new"

}

# -----------------------------
# Security Group
# -----------------------------
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-security-group"
  description = "Allow HTTP traffic"

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -----------------------------
# Task Definition
# -----------------------------
resource "aws_ecs_task_definition" "app" {
  family                   = "swarali-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = "arn:aws:iam::160932097162:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name  = "swarali-container"
      image = "160932097162.dkr.ecr.us-east-1.amazonaws.com/swarali-web-app:latest"

      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
    }
  ])
}

# -----------------------------
# Default VPC (use existing)
# -----------------------------
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# -----------------------------
# ECS Service
# -----------------------------
resource "aws_ecs_service" "app_service" {
  name            = "swarali-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = data.aws_subnets.default.ids
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}