
resource "aws_sfn_state_machine" "sfn_state_machine" {
  for_each = toset([for x in fileset("${path.module}/sfn", "**") : split(".", split("/", "${x}")[0])[0]])
  name     = each.key
  role_arn = "arn:aws:iam::${var.account}:role/stepfunction_trust_policy"

  definition = templatefile("${path.module}/sfn/${each.key}.json", { 
    # lambdas = {
    # for key, obj in aws_lambda_function.lambda_function: split("/", "${key}")[1] => obj.arn
    # }
    test = "test"
    })

  # depends_on = [
  #   aws_lambda_function.lambda_function
  # ]
}
