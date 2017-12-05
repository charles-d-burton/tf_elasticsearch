output "domain_arn" {
  value = "${aws_elasticsearch_domain.elk.arn}"
}

output "domain_endpoint" {
  value = "${aws_elasticsearch_domain.elk.endpoint}"
}

output "domain_id" {
  value = "${aws_elasticsearch_domain.elk.domain_id}"
}

output "logger_role_arn" {
  value = "${aws_iam_role.logger.arn}"
}
