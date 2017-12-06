provider "aws" {
  region = "${var.region}"
}

# cluster policy document
data "aws_iam_policy_document" "elk_cluster" {
  statement {
    actions = [
      "es:*",
    ]

    principals {
      type = "AWS"

      identifiers = ["${var.es_publish_role_arns}"]
    }

    resources = [
      "${aws_elasticsearch_domain.elk.arn}/*",
      "${aws_elasticsearch_domain.elk.arn}",
    ]
  }

  statement {
    actions = [
      "es:*",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "${aws_iam_role.logger.arn}",
      ]
    }

    resources = [
      "${aws_elasticsearch_domain.elk.arn}/*",
      "${aws_elasticsearch_domain.elk.arn}",
    ]
  }

  statement {
    actions = [
      "es:ESHttpGet",
      "es:ESHttpHead",
    ]

    principals {
      type        = "AWS"
      identifiers = "${var.kibana_role_arns}"
    }

    resources = [
      "${aws_elasticsearch_domain.elk.arn}/*",
    ]
  }

  statement {
    actions = [
      "es:ESHttp*",
    ]

    resources = [
      "${aws_elasticsearch_domain.elk.arn}/*",
      "${aws_elasticsearch_domain.elk.arn}",
    ]

    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"

      values = ["${var.ip_whitelist}"]
    }
  }
}

# iam role policy
data "aws_iam_policy_document" "logger" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "lambda.amazonaws.com",
      ]
    }
  }
}
