# elasticsearch 5.3 cluster in public
resource "aws_elasticsearch_domain" "elk" {
  count                 = "${var.use_vpc ? 0 : 1}"
  domain_name           = "${var.domain_name}"
  elasticsearch_version = "${var.elasticsearch_version}"

  cluster_config {
    instance_type            = "${var.instance_type}"
    instance_count           = "${var.instance_count}"
    zone_awareness_enabled   = "${var.zone_awareness_enabled}"
    dedicated_master_enabled = "${var.dedicated_master_enabled}"
    dedicated_master_type    = "${var.dedicated_master_type}"
    dedicated_master_count   = "${var.dedicated_master_count}"
  }

  ebs_options {
    ebs_enabled = true
    volume_type = "${var.volume_type}"
    volume_size = "${var.volume_size}"
  }
}

# elasticsearch 5.3 cluster in vpc
resource "aws_elasticsearch_domain" "elk_vpc" {
  count                 = "${var.use_vpc ? 1 : 0}"
  domain_name           = "${var.domain_name}"
  elasticsearch_version = "${var.elasticsearch_version}"

  cluster_config {
    instance_type            = "${var.instance_type}"
    instance_count           = "${var.instance_count}"
    zone_awareness_enabled   = "${var.zone_awareness_enabled}"
    dedicated_master_enabled = "${var.dedicated_master_enabled}"
    dedicated_master_type    = "${var.dedicated_master_type}"
    dedicated_master_count   = "${var.dedicated_master_count}"
  }

  ebs_options {
    ebs_enabled = true
    volume_type = "${var.volume_type}"
    volume_size = "${var.volume_size}"
  }
}

# cluster iam policy
resource "aws_elasticsearch_domain_policy" "elk" {
  domain_name     = "${aws_elasticsearch_domain.elk.domain_name}"
  access_policies = "${data.aws_iam_policy_document.elk_cluster.json}"
}

# iam role allowing full access to logging cluster
resource "aws_iam_role" "logger" {
  name               = "elk-logger-${var.region}"
  assume_role_policy = "${data.aws_iam_policy_document.logger.json}"
}
