resource "aws_ecs_cluster" "cluster" {
  name               = var.name
  capacity_providers = ["FARGATE_SPOT", "FARGATE"]
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}
