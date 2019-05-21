output "this_mediaconvert_role_arn" {
  description = "IAM role arn"
  value       = "${aws_iam_role.mediaconvert.arn}"
}

output "this_lambda_role_arn" {
  description = "IAM role arn"
  value       = "${aws_iam_role.lambda.arn}"
}

output "this_lambda_name" {
  description = "Lambda name"
  value       = "${aws_lambda_function.this.function_name}"
}

output "this_lambda_arn" {
  description = "Lambda arn"
  value       = "${aws_lambda_function.this.arn}"
}

output "this_cloudwatch_event_rule_name" {
  description = "Cloudwatch event rule name"
  value       = "${aws_cloudwatch_event_rule.this.name}"
}

output "this_cloudwatch_event_rule_arn" {
  description = "Cloudwatch event rule arn"
  value       = "${aws_cloudwatch_event_rule.this.arn}"
}
