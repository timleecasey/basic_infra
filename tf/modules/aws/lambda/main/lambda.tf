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
  tags = local.tags
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
  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "function_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# A VPC-attached function needs to manage its network interfaces.
resource "aws_iam_role_policy_attachment" "vpc_access" {
  count      = local.in_vpc ? 1 : 0
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_cloudwatch_log_group" "function" {
  name              = "/aws/lambda/${local.function_name}"
  retention_in_days = var.log_retention_days
  tags              = local.tags
}

resource "aws_lambda_function" "function_def" {
  function_name = local.function_name
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = var.image_uri
  timeout       = var.timeout
  memory_size   = var.memory_size
  architectures = var.architectures

  environment {
    variables = local.env_vars
  }

  dynamic "vpc_config" {
    for_each = local.in_vpc ? [1] : []
    content {
      subnet_ids         = var.subnet_ids
      security_group_ids = var.security_group_ids
    }
  }

  tags = local.tags

  depends_on = [
    aws_cloudwatch_log_group.function,
    aws_iam_role_policy_attachment.function_logs,
    aws_iam_role_policy_attachment.vpc_access,
  ]
}

resource "aws_lambda_function_url" "url" {
  count              = var.function_url ? 1 : 0
  function_name      = aws_lambda_function.function_def.function_name
  authorization_type = var.function_url_auth_type
}

# An auth-NONE function URL is only reachable once the function's resource
# policy lets anyone invoke it through the URL. Function URLs created since
# October 2025 need both statements: InvokeFunctionUrl, and InvokeFunction
# limited to invocations that arrive via the URL.
resource "aws_lambda_permission" "public_url" {
  count                  = var.function_url && var.function_url_auth_type == "NONE" ? 1 : 0
  statement_id           = "FunctionURLAllowPublicAccess"
  action                 = "lambda:InvokeFunctionUrl"
  function_name          = aws_lambda_function.function_def.function_name
  principal              = "*"
  function_url_auth_type = "NONE"
}

resource "aws_lambda_permission" "public_url_invoke" {
  count                    = var.function_url && var.function_url_auth_type == "NONE" ? 1 : 0
  statement_id             = "FunctionURLInvokeAllowPublicAccess"
  action                   = "lambda:InvokeFunction"
  function_name            = aws_lambda_function.function_def.function_name
  principal                = "*"
  invoked_via_function_url = true
}
