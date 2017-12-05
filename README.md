# tf-elk
terraform module for elk logging on aws

## Getting Started
```
module "elk" {
  source = "git@github.com:GaiamTV/tf-elk?ref=v1.0.0"
  dedicated_master_count = 4
  dedicated_master_type = "m3.medium.elasticsearch"
}
```