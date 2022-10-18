#Output ALB dns when terraform is completed
output "ALB_DNS" {
  value       = module.alb.alb_dns
  description = "The ID of the alb security group."
}
