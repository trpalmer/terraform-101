data "aws_iam_policy_document" "assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cowsay" {
  name_prefix        = "${local.product_name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume-role-policy.json
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "cowsay" {
  role       = aws_iam_role.cowsay.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "allowall" {
  statement {
    sid    = "PublicInvoke"
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction",
    ]
    resources = [aws_lambda_function.cowsay.arn]
  }
}

resource "aws_iam_role_policy" "cowsay" {
  name_prefix = "${local.product_name}-policy"
  role        = aws_iam_role.cowsay.name
  policy      = data.aws_iam_policy_document.allowall.json
}
