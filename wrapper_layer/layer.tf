# data "archive_file" "archive" {
#   type        = "zip"
#   source_dir  = "${path.module}/layer"
#   output_path = "${path.module}/layer/layer.zip"
# }

resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = "${path.module}/layer/wrapper.zip"
  layer_name = "wrapper"

  compatible_runtimes = ["python3.9"]
}

output "layer_arn" {
  value = aws_lambda_layer_version.lambda_layer.arn
}
