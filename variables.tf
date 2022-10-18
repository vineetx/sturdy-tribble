############
## Common ##
############

variable "access_key" {
}

variable "secret_key" {
}

variable "region" {
  default     = "us-east-1"
  type        = string
  description = "Region of the VPC"
}

variable "name" {
  default     = "Default"
  type        = string
  description = "Name of the VPC "
}

variable "tags" {
  default     = { environment = "image-1234" }
  type        = map(string)
  description = "Extra tags to attach to the VPC resources"
}

#########
## ALB ##
#########

variable "internal" {
  default     = false
  type        = string
  description = "If true, the LB will be internal."
}

#default is good
variable "idle_timeout" {
  default     = 60
  type        = string
  description = "The time in seconds that the connection is allowed to be idle."
}

#default is good
variable "enable_deletion_protection" {
  default     = true
  type        = string
  description = "If true, deletion of the load balancer will be disabled via the AWS API."
}

#default is good
variable "enable_http2" {
  default     = true
  type        = string
  description = "Indicates whether HTTP/2 is enabled in application load balancers."
}

#default is good
variable "ip_address_type" {
  default     = "ipv4"
  type        = string
  description = "The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack."
}

#default is good
variable "ssl_policy" {
  default     = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
  type        = string
  description = "The name of the SSL Policy for the listener. Required if protocol is HTTPS."
}

#default is good
variable "source_cidr_blocks" {
  default     = ["0.0.0.0/0"]
  type        = list(string)
  description = "List of source CIDR blocks."
}

#default is good
variable "http_port" {
  default     = 80
  type        = string
  description = "The HTTP port."
}

#################
## ECS Service ##
#################

variable "minimum_healthy_percent" {
  type    = number
  default = 100
}

variable "maximum_healthy_percent" {
  type    = number
  default = 200
}

#default is good for prod
variable "target_group_port" {
  default     = "80"
  type        = string
  description = "The port on which targets receive traffic, unless overridden when registering a specific target."
}

#default is good for prod
variable "target_group_protocol" {
  default     = "HTTP"
  type        = string
  description = "The protocol to use for routing traffic to the targets. Should be one of HTTP or HTTPS."
}

#default is good for prod
variable "target_type" {
  default     = "ip"
  type        = string
  description = "The type of target that you must specify when registering targets with this target group. The possible values are instance or ip."
}

#default is good for prod
variable "deregistration_delay" {
  default     = "60"
  type        = string
  description = "The amount time for the load balancer to wait before changing the state of a deregistering target from draining to unused."
}

#default is good for prod
variable "health_check_path" {
  default     = "/"
  type        = string
  description = "The destination for the health check request."
}

#default is good for prod
variable "health_check_healthy_threshold" {
  default     = "2"
  type        = string
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy."
}

#default is good for prod
variable "health_check_unhealthy_threshold" {
  default     = "8"
  type        = string
  description = "The number of consecutive health check failures required before considering the target unhealthy."
}

#default is good for prod
variable "health_check_timeout" {
  default     = "5"
  type        = string
  description = "The amount of time, in seconds, during which no response means a failed health check."
}

#default is good for prod
variable "health_check_interval" {
  default     = "15"
  type        = string
  description = "The approximate amount of time, in seconds, between health checks of an individual target."
}

#default is good for prod
variable "health_check_matcher" {
  default     = "200-299"
  type        = string
  description = "The HTTP codes to use when checking for a successful response from a target."
}

#default is good for prod
variable "health_check_protocol" {
  default     = "HTTP"
  type        = string
  description = "The protocol to use to connect with the target."
}
