output "security_group_id" {
  value       = join("", aws_security_group.default.*.id)
  description = "The ID of the alb security group."
}

output "alb_dns" {
  value       = aws_lb.default.dns_name
  description = "DNS of ALB."
}
