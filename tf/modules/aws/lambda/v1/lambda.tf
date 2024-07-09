
resource "aws_iam_role" "lambda_role" {
  name = "role-${var.env}-${var.shreg}-${var.tag}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com",
      },
    }],
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name = "policy-${var.env}-${var.shreg}-${var.tag}"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
      ],
      Effect   = "Allow",
      Resource = "arn:aws:logs:*:*:*",
    }],
  })
}

resource "aws_iam_role_policy_attachment" "function_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}


data "aws_caller_identity" "current" {
}

locals {
  account_id = data.aws_caller_identity.current.account_id
}


resource "aws_lambda_function" "function_def" {
  timeout       = 30
  function_name = "l-${var.env}-${var.tag}"
  handler       = "lambda_function.lambda_handler"
  runtime       = "provided.al2"
  role          = aws_iam_role.lambda_role.arn
  #filename      = "L-${var.env}-${var.tag}"
  #s3_bucket     = "ch-${var.env}-lambda"
  #s3_key        = "${var.env}/${var.tag}/L-${var.env}-${var.tag}.zip"
  image_uri     = "${local.account_id}.dkr.ecr.us-west-1.amazonaws.com/prod-usw1-chapi:latest"
  package_type  = "Image"
  environment {
    variables = {
      GIN_MODE = "${var.gin_mode}"
    }
  }
  lifecycle {
    ignore_changes = [ handler, runtime ]
  }
}


