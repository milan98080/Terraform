resource "aws_ecs_cluster" "ml_cluster" {
  name = "ml-cluster"
}

resource "aws_ecs_task_definition" "ml_task" {
  family                   = "ml-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "4096"
  memory                   = "8192"

  container_definitions = jsonencode([
    {
      name      = "ml-container"
      image     = "your-ml-image"
      cpu       = 4096
      memory    = 8192
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "ml_service" {
  name            = "ml-service"
  cluster         = aws_ecs_cluster.ml_cluster.id
  task_definition = aws_ecs_task_definition.ml_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [var.subnet_ml] 
    security_groups = [aws_security_group.ml_sg.id]
    assign_public_ip = true
  }
}

resource "aws_security_group" "ml_sg" {
  name = "ml-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = [var.backend_sg_id]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


