output "domain_arn" {
  value = "${var.use_vpc ? aws_elasticsearch_domain.elk_vpc.arn : aws_elasticsearch_domain.elk.arn }"
}

output "domain_endpoint" {
  value = "${var.use_vpc ? aws_elasticsearch_domain.elk_vpc.endpoint : aws_elasticsearch_domain.elk.endpoint }"
}

output "domain_id" {
  value = "${var.use_vpc ? aws_elasticsearch_domain.elk_vpc.domain_id : aws_elasticsearch_domain.elk.domain_id }"
}

output "logger_role_arn" {
  value = "${aws_iam_role.logger.arn}"
}
