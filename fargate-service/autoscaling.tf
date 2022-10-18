# resource "aws_appautoscaling_target" "_" {
#   max_capacity       = var.maximum_count == "" ? var.desired_count : var.maximum_count
#   min_capacity       = var.minimum_count == "" ? var.desired_count : var.minimum_count
#   resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.services.name}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace  = "ecs"
# }
#
# resource "aws_appautoscaling_policy" "cpu" {
#   name               = "cpu"
#   service_namespace  = aws_appautoscaling_target._.service_namespace
#   scalable_dimension = aws_appautoscaling_target._.scalable_dimension
#   resource_id        = aws_appautoscaling_target._.resource_id
#   policy_type        = "TargetTrackingScaling"
#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageCPUUtilization"
#     }
#     target_value       = 60
#     scale_in_cooldown  = 180
#     scale_out_cooldown = 180
#   }
# }
#
# resource "aws_appautoscaling_policy" "memory" {
#   name               = "memory"
#   service_namespace  = aws_appautoscaling_target._.service_namespace
#   scalable_dimension = aws_appautoscaling_target._.scalable_dimension
#   resource_id        = aws_appautoscaling_target._.resource_id
#   policy_type        = "TargetTrackingScaling"
#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageMemoryUtilization"
#     }
#     target_value       = 75
#     scale_in_cooldown  = 180
#     scale_out_cooldown = 180
#   }
# }
