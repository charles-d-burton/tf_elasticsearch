variable "env" {}
variable "region" {}

variable "domain_endpoint" {
  type        = "string"
  description = "The domain endpoint of the elasticsearch cluster to publish to"
}
