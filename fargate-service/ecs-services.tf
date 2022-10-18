resource "aws_lb_target_group" "service" {
  name                 = "${var.name}-tg"
  vpc_id               = var.vpc_id
  port                 = var.target_group_port
  protocol             = var.target_group_protocol
  target_type          = var.target_type
  deregistration_delay = var.deregistration_delay
  health_check {
    path                = var.health_check_path
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    timeout             = var.health_check_timeout
    interval            = var.health_check_interval
    matcher             = var.health_check_matcher
    protocol            = var.health_check_protocol
  }
  tags = merge(
    {
      Name = "${var.name}-tg"
    },
    var.tags
  )
}

resource "aws_ecs_service" "services" {
  name                               = var.name
  cluster                            = var.cluster_arn
  task_definition                    = var.name
  desired_count                      = 1
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  deployment_minimum_healthy_percent = var.minimum_healthy_percent
  deployment_maximum_percent         = var.maximum_healthy_percent
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }
  network_configuration {
    security_groups = [aws_security_group.fargate_service.id]
    subnets         = var.subnets
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.service.arn
    container_name   = var.name
    container_port   = tonumber(var.port)
  }
  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }
  # depends_on = [
  #   aws_lb_listener_rule.routing
  # ]
}

resource "aws_security_group" "fargate_service" {
  name   = "${var.name}-sg"
  vpc_id = var.vpc_id

  tags = merge(
    {
      Name = "${var.name}-sg"
    },
    var.tags
  )
}

resource "aws_security_group_rule" "ingress_http" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id       = var.lb_security_group
  security_group_id = aws_security_group.fargate_service.id
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.fargate_service.id
}
