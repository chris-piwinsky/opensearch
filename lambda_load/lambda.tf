data "archive_file" "os_file" {
  type        = "zip"
  source_file = "${path.module}/lambda_load/lambda_function.py"
  output_path = "${path.module}/lambda_load/lambda_function.zip"
}

resource "aws_lambda_function" "os_bulk_lambda" {
  # filename         = data.archive_file.os_file.output_path
  filename         = data.archive_file.os_file.output_path
  function_name    = "os_load"
  role             = aws_iam_role.os_role.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.os_file.output_base64sha256
  runtime          = "python3.9"
  layers           = var.layers
  # vpc_config {
  #   security_group_ids = var.security_group_ids
  #   subnet_ids         = var.subnet_ids
  # }

  environment {
    variables = {
      SSM_PARAMETER = var.ssm_parameter_name
      OS_URI        = var.os_uri
      MASTER_USER   = var.master_user
    }
  }
}
