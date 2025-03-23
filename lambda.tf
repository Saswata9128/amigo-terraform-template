#Main Method Lambda

# Create the local zip for the packaged src GET code

data "archive_file" "lambda_zip" {
    for_each = toset([for x in fileset("${path.module}/src", "**") : split("/", "${x}")[0]])
    type = "zip"
    source_dir = "${path.module}/src/${each.key}"
    output_path = "${path.module}/${each.key}.zip"
}


resource "aws_lambda_function" "lambda_function" {
  for_each = data.archive_file.lambda_zip
  filename = "${data.archive_file.lambda_zip[each.key].output_path}"
  function_name = each.key
  role = "${aws_iam_role.iam_for_lambda.arn}"
  handler = "${each.key}.lambda_handler"
  source_code_hash = "${data.archive_file.lambda_zip[each.key].output_base64sha256}"
  runtime = var.runtime
  timeout = 900
  memory_size = 10240

  #vpc_config {
    #subnet_ids         = ["subnet-04098dd11bf3ec39d, subnet-04dc3c63241817dc0, subnet-0cb42457b3db27ae3"]
    #security_group_ids = ["sg-0ec1fd674ed32a5c6"]
  #}
}
