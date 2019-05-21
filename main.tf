resource "aws_iam_role" "mediaconvert" {
  name = "${format("%s-%s-converter-mediaconvert-role", var.project, var.environment)}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect":"Allow",
      "Principal":
        {
          "Service":"mediaconvert.amazonaws.com"
        },
      "Action":"sts:AssumeRole"
    }
  ]
}
EOF

  tags = "${merge(var.tags, map("Name", format("%s-%s-converter-mediaconvert-role", var.project, var.environment)))}"
}

resource "aws_iam_role_policy_attachment" "convert_apigateway" {
  role       = "${aws_iam_role.mediaconvert.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess"
}

resource "aws_iam_role_policy_attachment" "convert_s3" {
  role       = "${aws_iam_role.mediaconvert.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role" "lambda" {
  name = "${format("%s-%s-converter-lambda-role", var.project, var.environment)}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = "${merge(var.tags, map("Name", format("%s-%s-converter-lambda-role", var.project, var.environment)))}"
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = "${aws_iam_role.lambda.name}"
  policy_arn = "${aws_iam_policy.lambda_logging.arn}"
}

resource "aws_lambda_function" "this" {
  function_name    = "${format("%s-%s-converter-result-lambda", var.project, var.environment)}"
  filename         = "${path.module}/lambda.zip"
  description      = "${format("%s-%s Functions that store MediaConvert result data ", var.project, var.environment)}"
  role             = "${aws_iam_role.lambda.arn}"
  handler          = "function.handler"
  source_code_hash = "${base64sha256(file("${path.module}/lambda.zip"))}"
  runtime          = "python3.7"

  environment {
    variables = {
      API_ENDPOINT   = "${var.api_endpoint}"
      JWT_SECRET_KEY = "${var.jwt_secret_key}"
    }
  }

  tags = "${merge(var.tags, map("Name", format("%s-%s-converter-result-lambda", var.project, var.environment)))}"
}

resource "aws_cloudwatch_event_rule" "this" {
  name        = "${format("%s-%s-cw-converter", var.project, var.environment)}"
  description = "MediaConvert Job State Change"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.mediaconvert"
  ],
  "detail-type": [
    "MediaConvert Job State Change"
  ],
  "detail": {
    "status": [
      "COMPLETE",
      "ERROR",
      "CANCELED"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "this" {
  rule = "${aws_cloudwatch_event_rule.this.name}"
  arn  = "${aws_lambda_function.this.arn}"
}

resource "aws_lambda_permission" "this" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.this.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.this.arn}"
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = 14
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "${format("%s-%s-converter-result-lambda-logging", var.project, var.environment)}"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}
