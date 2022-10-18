locals {
  env                 = lookup(var.tags, "environment")
  name                = "${local.env}-${var.name}"
}

module "alb" {
  source                     = "./alb"
  name                       = local.name
  internal                   = var.internal
  subnets                    = data.aws_subnet_ids.subnets.ids
  idle_timeout               = var.idle_timeout
  enable_deletion_protection = var.enable_deletion_protection
  enable_http2               = var.enable_http2
  ip_address_type            = var.ip_address_type
  source_cidr_blocks         = var.source_cidr_blocks
  http_port                  = var.http_port
  ssl_policy                 = var.ssl_policy
  vpc_id                     = data.aws_vpc.default_vpc.id
  tags                       = var.tags
  account_id                 = data.aws_caller_identity._.account_id
  cluster_arn                      = module.ecs.cluster_arn
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
  ecs_cluster_name                 = module.ecs.cluster_name
  maximum_count                    = 3
  desired_count                    = 2
  minimum_count                    = 1
  task_role                        = data.aws_iam_role.task_ecs.arn
  region                           = var.region
}

module "ecs" {
  source = "./ecs"
  name   = local.name
  tags   = var.tags
}

# module "ecs-services" {
#   source                           = "./ecs-services"
#   name                             = "flask-app"
#   health_check_path                = "/"
#   port                             = 5001
#   host_header                      = each.value.host_header
#   lb_443_listener_arn              = module.alb.alb_443_listener_arn
#   cluster_arn                      = module.ecs.cluster_arn
#   vpc_id                           = data.aws_vpc.default_vpc
#   security_group                   = module.sg-association.security_group_id
#   subnets                          = data.aws_subnet_ids.subnets
#   minimum_healthy_percent          = var.minimum_healthy_percent
#   maximum_healthy_percent          = var.maximum_healthy_percent
#   target_group_port                = var.target_group_port
#   target_group_protocol            = var.target_group_protocol
#   target_type                      = var.target_type
#   deregistration_delay             = var.deregistration_delay
#   health_check_healthy_threshold   = var.health_check_healthy_threshold
#   health_check_unhealthy_threshold = var.health_check_unhealthy_threshold
#   health_check_timeout             = var.health_check_timeout
#   health_check_interval            = var.health_check_interval
#   health_check_matcher             = var.health_check_matcher
#   health_check_protocol            = var.health_check_protocol
#   tags                             = var.tags
#   ecs_cluster_name                 = module.ecs.cluster_name
#   maximum_count                    = var.maximum_count
#   desired_count                    = var.desired_count
#   minimum_count                    = var.minimum_count
# }
