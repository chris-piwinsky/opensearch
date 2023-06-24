data "aws_iam_policy_document" "lambda_invoke_policy" {
  statement {
    sid = "InvokeLambda"

    actions = [
      "lambda:GetFunction",
      "lambda:InvokeAsync",
      "lambda:InvokeFunction"
    ]

    resources = [
      "arn:aws:lambda:::*",
    ]
  }
}

resource "aws_iam_policy" "lambda_invoke_policy" {
  name   = "rds_lambda_pw_invoke_policy"
  policy = data.aws_iam_policy_document.lambda_invoke_policy.json
}

data "aws_iam_policy_document" "os_admin_policy" {
  statement {
    sid = "opensearch"

    actions = [
      "es:*",
      "ssm:*"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "os_admin_policy" {
  name   = "os_admin_policy"
  policy = data.aws_iam_policy_document.os_admin_policy.json
}

data "aws_iam_policy_document" "AWSLambdaTrustPolicy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "os_role" {
  name               = "os_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.AWSLambdaTrustPolicy.json
}

resource "aws_iam_role_policy_attachment" "vpc_policy_attach" {
  role       = aws_iam_role.os_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "os_admin_policy_attach" {
  role       = aws_iam_role.os_role.name
  policy_arn = aws_iam_policy.os_admin_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_invoke_policy_attach" {
  role       = aws_iam_role.os_role.name
  policy_arn = aws_iam_policy.lambda_invoke_policy.arn
}
