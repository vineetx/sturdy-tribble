locals {
  security_group_name = "${var.name}-lb-sg"
  alb_name            = "${var.name}-lb"
  default_tg_name     = "${var.name}-tg"
}

resource "aws_s3_bucket" "alb" {
  count         = lookup(var.tags, "environment") == "prod" ? 1 : 0
  bucket_prefix = "alb-logs-"
  acl           = "private"
  force_destroy = true
}

data "aws_iam_policy_document" "put_alb_logs" {
  count = lookup(var.tags, "environment") == "prod" ? 1 : 0
  statement {
    principals {
      type        = "AWS"
      identifiers = [var.account_id]
    }
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.alb[0].arn}/*"
    ]
  }
  statement {
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.alb[0].arn}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control"
      ]
    }
  }
  statement {
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = [
      "s3:GetBucketAcl"
    ]
    resources = [
      aws_s3_bucket.alb[0].arn
    ]
  }
}

resource "aws_s3_bucket_policy" "put_alb_logs" {
  count  = lookup(var.tags, "environment") == "prod" ? 1 : 0
  bucket = aws_s3_bucket.alb[0].id
  policy = data.aws_iam_policy_document.put_alb_logs[0].json
}

resource "aws_lb" "default" {
  load_balancer_type         = "application"
  name                       = local.alb_name
  internal                   = var.internal
  security_groups            = [aws_security_group.default.id]
  subnets                    = var.subnets
  idle_timeout               = var.idle_timeout
  enable_deletion_protection = var.enable_deletion_protection
  enable_http2               = var.enable_http2
  ip_address_type            = var.ip_address_type
  dynamic "access_logs" {
    for_each = tobool(lookup(var.tags, "environment") == "prod") ? [1] : []
    content {
      bucket  = aws_s3_bucket.alb[0].id
      prefix  = "logs"
      enabled = true
    }
  }
  tags = merge(
    {
      Name = local.alb_name
    },
    var.tags
  )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.default.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = module.service.target_group_arn
  }
}

module "service" {
  source                             = "../fargate-service"
  name                             = "flask-app"
  health_check_path                = "/"
  port                             = 5001
  cluster_arn                      = var.cluster_arn
  vpc_id                           = var.vpc_id
  lb_security_group                = aws_security_group.default.id
  subnets                          = var.subnets
  minimum_healthy_percent          = var.minimum_healthy_percent
  maximum_healthy_percent          = var.maximum_healthy_percent
  target_group_port                = var.target_group_port
  target_group_protocol            = var.target_group_protocol
  target_type                      = var.target_type
  deregistration_delay             = var.deregistration_delay
  health_check_healthy_threshold   = var.health_check_healthy_threshold
  health_check_unhealthy_threshold = var.health_check_unhealthy_threshold
  health_check_timeout             = var.health_check_timeout
  health_check_interval            = var.health_check_interval
  health_check_matcher             = var.health_check_matcher
  health_check_protocol            = var.health_check_protocol
  tags                             = var.tags
  ecs_cluster_name                 = var.ecs_cluster_name
  maximum_count                    = var.maximum_count
  desired_count                    = var.desired_count
  minimum_count                    = var.minimum_count
  task_role                        = var.task_role
  region                           = var.region

  depends_on = [aws_security_group.default]
}

resource "aws_security_group" "default" {
  name   = local.security_group_name
  vpc_id = var.vpc_id

  tags = merge(
    {
      Name = local.security_group_name
    },
    var.tags
  )
}

resource "aws_security_group_rule" "ingress_http" {
  type              = "ingress"
  from_port         = var.http_port
  to_port           = var.http_port
  protocol          = "tcp"
  cidr_blocks       = var.source_cidr_blocks
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}
