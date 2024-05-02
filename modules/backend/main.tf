resource "aws_ecs_cluster" "backend_cluster" {
  name = "backend-cluster"
}

resource "aws_ecr_repository" "backend_repo" {
  name = "backend-repo"
}

resource "aws_cloudwatch_log_group" "backend_logs" {
  name = "/ecs/backend-logs"
  retention_in_days = 30
}

resource "aws_ecs_task_definition" "backend_task" {
  family                   = "backend-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "backend-container"
      image     = "${aws_ecr_repository.backend_repo.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.backend_logs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "backend"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "backend_service" {
  name            = "backend-service"
  cluster         = aws_ecs_cluster.backend_cluster.id
  task_definition = aws_ecs_task_definition.backend_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [aws_security_group.backend_sg.id]
    assign_public_ip = true
  }
}