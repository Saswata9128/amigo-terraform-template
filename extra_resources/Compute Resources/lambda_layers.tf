#Main Method Lambda Layer resource

resource "aws_lambda_layer_version" "lambda_layer" {
  for_each = fileset("${path.module}/layers", "*.zip")
  filename   = "layers/${each.value}"
  layer_name = replace(each.key, ".zip", "")
  description = each.key
  skip_destroy = true
  compatible_runtimes = ["dotnet6", "dotnetcore3.1", "python3.9"]
}
