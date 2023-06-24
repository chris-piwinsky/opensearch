resource "aws_cloudwatch_log_group" "opensearch_log_group_index_slow_logs" {
  name              = "/aws/opensearch/${var.domain}/index-slow"
  retention_in_days = 14
}


resource "aws_cloudwatch_log_group" "opensearch_log_group_search_slow_logs" {
  name              = "/aws/opensearch/${var.domain}/search-slow"
  retention_in_days = 14
}


resource "aws_cloudwatch_log_group" "opensearch_log_group_es_application_logs" {
  name              = "/aws/opensearch/${var.domain}/es-application"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_resource_policy" "opensearch_log_resource_policy" {
  policy_name = "${var.domain}-domain-log-resource-policy"

  policy_document = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
        "logs:CreateLogStream"
      ],
      "Resource": [
        "${aws_cloudwatch_log_group.opensearch_log_group_index_slow_logs.arn}:*",
        "${aws_cloudwatch_log_group.opensearch_log_group_search_slow_logs.arn}:*",
        "${aws_cloudwatch_log_group.opensearch_log_group_es_application_logs.arn}:*"
      ]
    }
  ]
}
CONFIG
}