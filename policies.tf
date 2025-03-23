#Lambda Policy
data "aws_iam_policy_document" "lambda" {
  statement {
    actions   = ["sts:AssumeRole"]
    effect    = "Allow"
    principals {
      type = "AWS"
      identifiers = ["*"]
    }

  }
}

data "aws_iam_policy_document" "lambda_table_policy" {
  statement {
    actions =  [
     "rds:executestatement"
    ]
    effect = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda.json
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.iam_for_lambda.id
  policy = data.aws_iam_policy_document.lambda_table_policy.json
}



