variable "create" {
  type    = bool
  default = true
}

variable "alarm_name" {
  description = "The descriptive name for the alarm. This name must be unique within the user's AWS account."
  type        = string
}

variable "alarm_description" {
  description = "The description for the alarm."
  type        = string
  default     = null
}

variable "comparison_operator" {
  description = <<EOF
The arithmetic operation to use when comparing the specified Statistic and Threshold. The specified Statistic value is used as the first operand.
Either of the following is supported: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold.
EOF
  type        = string
  default     = "GreaterThanOrEqualToThreshold"
}

variable "evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold."
  type        = number
  default     = 3
}

variable "threshold" {
  description = "The value against which the specified statistic is compared."
  type        = number
  default     = null
}

variable "threshold_metric_id" {
  description = "If this is an alarm based on an anomaly detection model, make this value match the ID of the ANOMALY_DETECTION_BAND function."
  type        = string
  default     = null
}

variable "unit" {
  description = <<EOF
The unit for the alarm's associated metric. Support value is Count.
  see - https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/cloudwatch_concepts.html#Unit
  Valid values: Bytes, Seconds, Count, Percent
EOF
  type        = string
  default     = null
}

variable "metric_name" {
  description = "The name for the alarm's associated metric. See docs for supported metrics."
  type        = string
  default     = null
}

variable "namespace" {
  description = "The namespace for the alarm's associated metric. See docs for the list of namespaces. See docs for supported metrics."
  type        = string
  default     = null
}

variable "period" {
  description = "The period in seconds over which the specified statistic is applied."
  type        = string
  default     = "60"
}

variable "statistic" {
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum"
  type        = string
  default     = null
}

variable "actions_enabled" {
  description = "Indicates whether or not actions should be executed during any changes to the alarm's state. Defaults to true."
  type        = bool
  default     = true
}

variable "datapoints_to_alarm" {
  description = "The number of datapoints that must be breaching to trigger the alarm."
  type        = number
  default     = null
}

variable "dimensions" {
  type        = any
  default     = null
  description = <<EOF
The dimensions for the alarm's associated metric.

  # for identifying resource
  dimensions = {
    InstanceId            = aws_instance.myEc2App.id
    Environment           = "Production"
    DBInstanceIdentifier  = "my-rds-instance"
    LoadBalancerName      = "my-elb-load-balancer-name"
    BucketName            = "my-bucket"
    ClusterName           = "my-cluster"
    ServiceName           = "my-service"
    TopicName             = "my-sns-topic"
  }

EOF
}

variable "alarm_actions" {
  type        = list(string)
  default     = null
  description = <<EOF
The list of actions to execute when this alarm transitions into an ALARM state from any other state. Each action is specified as an Amazon Resource Name (ARN).

  insufficient_data_actions = [
    aws_sns_topic.mySnsTopic.arn,          # in case of SNS Notification
    aws_autoscaling_policy.myappScale.arn, # in case of Auto Scaling action
    aws_ssm_document.mySsmRunCommand.arn,  # in case of Systems Manager action
    aws_lambda_function.myLambda.arn,      # in case of Lambda action
    arn:aws:automate:us-east-1:ec2:stop,   # in case of EC2 action, should define dimensions with InstanceId attribute
  ]

  # EC2 Action to stop the instance
  dimensions = {
    InstanceId = aws_instance.myEc2App.id
  }

EOF
}

variable "insufficient_data_actions" {
  type        = list(string)
  default     = []
  description = <<EOF
The list of actions to execute when this alarm transitions into an INSUFFICIENT_DATA state from any other state. Each action is specified as an Amazon Resource Name (ARN).

  insufficient_data_actions = [
    aws_sns_topic.mySnsTopic.arn,          # in case of SNS Notification
    aws_autoscaling_policy.myappScale.arn, # in case of Auto Scaling action
    aws_ssm_document.mySsmRunCommand.arn,  # in case of Systems Manager action
    aws_lambda_function.myLambda.arn,      # in case of Lambda action
    arn:aws:automate:us-east-1:ec2:stop,   # in case of EC2 action, should define dimensions with InstanceId attribute
  ]

  # EC2 Action to stop the instance
  dimensions = {
    InstanceId = aws_instance.myEc2App.id
  }
EOF
}

variable "ok_actions" {
  type        = list(string)
  default     = null
  description = <<EOF
The list of actions to execute when this alarm transitions into an OK state from any other state. Each action is specified as an Amazon Resource Name (ARN).

  ok_actions = [
    aws_sns_topic.mySnsTopic.arn,          # in case of SNS Notification
    aws_autoscaling_policy.myappScale.arn, # in case of Auto Scaling action
    aws_ssm_document.mySsmRunCommand.arn,  # in case of Systems Manager action
    aws_lambda_function.myLambda.arn,      # in case of Lambda action
    arn:aws:automate:us-east-1:ec2:stop,   # in case of EC2 action, should define dimensions with InstanceId attribute
  ]

  # EC2 Action to stop the instance
  dimensions = {
    InstanceId = aws_instance.myEc2App.id
  }

EOF
}

variable "extended_statistic" {
  description = "The percentile statistic for the metric associated with the alarm. Specify a value between p0.0 and p100."
  type        = string
  default     = null
}

variable "treat_missing_data" {
  description = "Sets how this alarm is to handle missing data points. The following values are supported: missing, ignore, breaching and notBreaching."
  type        = string
  default     = "missing"
}

variable "evaluate_low_sample_count_percentiles" {
  description = "Used only for alarms based on percentiles. If you specify ignore, the alarm state will not change during periods with too few data points to be statistically significant. If you specify evaluate or omit this parameter, the alarm will always be evaluated and possibly change state no matter how many data points are available. The following values are supported: ignore, and evaluate."
  type        = string
  default     = null
}

variable "metric_query" {
  type        = any
  default     = []
  description = <<EOF
Enables you to create an alarm based on a metric math expression. You may specify at most 20.

  metric_query = [
    {
      id          = "e1"
      expression  = "m1 + m2"
      label       = "The total number of queue messages"
      return_data = "true"
    },
    {
      id     = "m1"
      metric = [{
        metric_name = "MessageCount"
        namespace   = "AWS/AmazonMQ"
        period      = "60"
        stat        = "Maximum"
        unit        = "Count"
        dimensions  = {
          "Broker"      = "my-rabbit-mq"
          "Queue"       = "myapp.collector"
          "VirtualHost" = "/collector"
        }
      }]
    },
    {
      id     = "m2",
      metric = [{
        metric_name = "MessageCount"
        namespace   = "AWS/AmazonMQ"
        period      = "60"
        stat        = "Maximum"
        unit        = "Count"
        dimensions  = {
          "Broker"      = "my-rabbit-mq"
          "Queue"       = "myapp.process"
          "VirtualHost" = "/process"
        }
      }]
    },
  ]

EOF
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
