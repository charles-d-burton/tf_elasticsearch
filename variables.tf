variable "elasticsearch_version" {
  description = "The version of AWS supported ES to use"
  default     = "6.0"
}

variable "dedicated_master_count" {
  type        = "string"
  description = "number of dedicated master nodes"
  default     = 3
}

variable "dedicated_master_enabled" {
  type        = "string"
  description = "enable dedicated master nodes"
  default     = true
}

variable "dedicated_master_type" {
  type        = "string"
  description = "master node type"
  default     = "m4.large.elasticsearch"
}

variable "domain_name" {
  type        = "string"
  default     = "logs"
  description = "elasticsearch domain name"
}

variable "instance_count" {
  type        = "string"
  description = "number of cluster nodes"
  default     = 3
}

variable "instance_type" {
  type        = "string"
  description = "data node type"
  default     = "m4.large.elasticsearch"
}

variable "kibana_role_arns" {
  type        = "list"
  description = "list of iam role arns that should be allowed read access to kibana"
  default     = []
}

variable "es_publish_role_arns" {
  type        = "list"
  description = "list of iam role arns that should be able to publish data to ES"
  default     = []
}

variable "region" {
  type        = "string"
  description = "aws region"
  default     = "us-west-2"
}

variable "volume_size" {
  type        = "string"
  description = "cluster ebs volume size"
  default     = 100
}

variable "volume_type" {
  type        = "string"
  description = "The type of disk to use"
  default     = "gp2"
}

variable "zone_awareness_enabled" {
  type        = "string"
  description = "enable multi AZ support"
  default     = false
}

variable "ip_whitelist" {
  type        = "list"
  description = "List of ip addresses in CIDR notation to allow inbound access to, can be internal ip range"
  default     = []
}

variable "use_vpc" {
  description = "Set to false to expose cluster to the internet"
  default     = true
}

variable "subnets" {
  type        = "list"
  description = "Subnets to place ES nodes in when using VPC"
  default     = []
}

variable "vpc_id" {
  type        = "string"
  description = "The vpc of the subnets and security groups"
  default     = ""
}
