resource "aws_ecr_repository" "ecr" {
  name                 = var.name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}

resource "aws_ecs_task_definition" "services" {
  family                   = var.name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = var.task_role
  execution_role_arn       = var.task_role
  cpu                      = 256
  memory                   = 512
  container_definitions = jsonencode([
    {
      name      = var.name
      image     = "${aws_ecr_repository.ecr.repository_url}:1"
      essential = true
      portMappings = [
        {
          containerPort = tonumber(var.port)
        }
      ],
      readonlyRootFilesystem = false
      # logConfiguration = {
      #   "logDriver" = "awslogs",
      #   "options" = {
      #     "awslogs-group" : "/ecs/${var.name}",
      #     "awslogs-region" : var.region,
      #     "awslogs-stream-prefix" : "ecs"
      #   }
      # },
      ulimits = [
        {
          "name" : "core",
          "softLimit" : 15360,
          "hardLimit" : 25600
        }
      ]

    }
  ])
}

# resource "aws_cloudwatch_log_group" "default" {
#   name              = "/ecs/${var.name}"
#   retention_in_days = 30
#   tags = merge(
#     {
#       Name = var.name
#     },
#     var.tags
#   )
# }
