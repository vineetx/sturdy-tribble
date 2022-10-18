#AWS Account access key and secret key
access_key = "access_key"
secret_key = "secret_key"
region = "eu-central-1"

name = "perks"
tags = { environment = "dev", version = "1.0", project = "xmax" }

#########
## ALB ##
#########

# If want a public facing ALB mark this as false.
internal = false

# should be changed

# Before running terraform request and a new certificate from AWS ACM and validate and enter ARN here
certificate_arn = ""

# If want to enable logs for ALB give bucket info.
# access_logs_bucket
# access_logs_prefix
# access_logs_enabled


##################
## ECS Services ##
##################

minimum_healthy_percent = 100
maximum_healthy_percent = 200
deregistration_delay    = 60
