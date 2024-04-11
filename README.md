# tfmodule-aws-metric-alarm

## Usage

### example

```hcl
module "ctx" {
  source  = "git::https://code.bespinglobal.com/scm/op/tfmodule-context.git?ref=v1.0.0"
  context = var.context
}

resource "aws_appautoscaling_policy" "this" {
  name               = "my-scaling-name"
  # ....
}

module "alm" {
  source              = "../"
  context             = module.ctx.context
  alarm_name          = "costdis-aws-process-cpu-high"
  alarm_actions       = [aws_appautoscaling_policy.this.arn]
  # ok_actions          = ["<ok_actions_arn>"]
  comparison_operator = "GreaterThanOrEqualToThreshold"
  metric_name         = "CPUUtilization"
  evaluation_periods  = 3
  threshold           = 60.0
  period              = 120
  statistic           = "Average"
  namespace           = "AWS/ECS"
  dimensions          = {
    ClusterName = "<cluster_name>"
    ServiceName = "<ecs_service_name>"
  }

}

```

### example for metric_query

```hcl

module "ctx" {
  source  = "git::https://code.bespinglobal.com/scm/op/tfmodule-context.git?ref=v1.0.0"
  context = local.context
}

resource "aws_appautoscaling_policy" "this" {
  name = "my-scaling-name"
  # ....
}

module "alm" {
  source        = "git::https://code.bespinglobal.com/scm/op/tfmodule-aws-metric-alarm.git?ref=v1.0.0"
  context       = module.ctx.context
  alarm_name    = "costdis-aws-process-ecss-sum-mq"
  alarm_actions = [aws_appautoscaling_policy.this.arn]
  threshold     = 0
  metric_query  = [
    {
      id          = "e1"
      expression  = "m1 + m2 + m3"
      label       = "The total number of queue messages"
      return_data = "true"
    },
    {
      id     = "m1"
      metric = [
        {
          metric_name = "MessageCount"
          namespace   = "AWS/AmazonMQ"
          period      = "60"
          stat        = "Maximum"
          unit        = "Count"
          dimensions  = {
            "Broker"      = "${local.name_prefix}-rabbitmq"
            "Queue"       = "cost.auto.savings.reserved.aws.pre.process"
            "VirtualHost" = "/cost"
          }
        }
      ]
    },
    {
      id     = "m2",
      metric = [
        {
          metric_name = "MessageCount"
          namespace   = "AWS/AmazonMQ"
          period      = "60"
          stat        = "Maximum"
          unit        = "Count"
          dimensions  = {
            "Broker"      = "${local.name_prefix}-rabbitmq"
            "Queue"       = "cost.auto.savings.reserved.aws.utilization.process"
            "VirtualHost" = "/cost"
          }
        }
      ]
    },
    {
      id     = "m3",
      metric = [
        {
          metric_name = "MessageCount"
          namespace   = "AWS/AmazonMQ"
          period      = "60"
          stat        = "Maximum"
          unit        = "Count"
          dimensions  = {
            "Broker"      = "${local.name_prefix}-rabbitmq"
            "Queue"       = "cost.auto.savings.reserved.aws.coverage.process"
            "VirtualHost" = "/cost"
          }
        }
      ]
    }
  ]
}

```