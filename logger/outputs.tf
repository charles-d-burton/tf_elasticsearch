output "lambda_to_es_arn" {
  value = "${aws_lambda_function.cw_to_es.arn}"
}

output "lambda_to_es_name" {
  value = "${aws_lambda_function.cw_to_es.function_name}"
}
