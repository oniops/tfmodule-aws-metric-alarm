output "id" {
  value = try( aws_cloudwatch_metric_alarm.this[0].id, "")
}

output "arn" {
  value = try( aws_cloudwatch_metric_alarm.this[0].arn, "")
}

output "alarm_actions" {
  value = try( aws_cloudwatch_metric_alarm.this[0].alarm_actions, "")
}

output "ok_actions" {
  value = try( aws_cloudwatch_metric_alarm.this[0].ok_actions, "")
}
