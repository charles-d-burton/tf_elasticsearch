data "terraform_remote_state" "cluster" {
  backend = "atlas"

  config {
    name = "gaia-engineering/us-west-2_es_logs"
  }
}

data "aws_iam_policy_document" "log_to_es" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]

    effect = "Allow"
  }

  statement {
    actions = [
      "es:ESHttpPost",
    ]

    resources = [
      "${data.terraform_remote_state.cluster.domain_arn}/*",
    ]

    effect = "Allow"
  }
}

data "aws_iam_policy_document" "log_to_es_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals = {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_policy" "log_to_es_policy" {
  name        = "log-to-es"
  description = "Policy to allow lambda function to publish to ES"
  policy      = "${data.aws_iam_policy_document.log_to_es.json}"
}

resource "aws_iam_role" "log_to_es_role" {
  name               = "log_to_es"
  path               = "/cloudwatch/"
  assume_role_policy = "${data.aws_iam_policy_document.log_to_es_role.json}"
}

resource "aws_iam_policy_attachment" "log_to_es_attach" {
  name       = "log_to_es_attachment"
  roles      = ["${aws_iam_role.log_to_es_role.name}"]
  policy_arn = "${aws_iam_policy.log_to_es_policy.arn}"
}

data "archive_file" "cw_to_es_lambda" {
  type        = "zip"
  source_file = "${path.module}/cw-to-es.js"
  output_path = "${path.module}/cw-to-es.zip"
  depends_on  = ["aws_iam_policy.log_to_es_policy"]
}

resource "aws_s3_bucket" "gaia_functions" {
  bucket = "gaia-${var.env}-${var.region}-logger"
  acl    = "private"

  //depends_on = ["archive_file.cw_to_es_lambda"]
}

resource "aws_s3_bucket_object" "cw_to_es_lambda" {
  key    = "cw-to-es.zip"
  bucket = "${aws_s3_bucket.gaia_functions.id}"
  source = "${path.module}/cw-to-es.zip"
  etag   = "${data.archive_file.cw_to_es_lambda.output_md5}"
}

resource "aws_lambda_function" "cw_to_es" {
  function_name = "cw-to-es"
  s3_bucket     = "${aws_s3_bucket.gaia_functions.id}"
  s3_key        = "${aws_s3_bucket_object.cw_to_es_lambda.id}"
  role          = "${aws_iam_role.log_to_es_role.arn}"
  handler       = "cw-to-es.handler"
  runtime       = "nodejs6.10"
  description   = "Forward cloudwatch logs to ElasticSearch"
  timeout       = "300"

  environment {
    variables = {
      ES_DOMAIN = "${data.terraform_remote_state.cluster.domain_endpoint}"
    }
  }

  //assume_role_policy = 
}
