variable "character" {
  type    = string
  default = "cow"
  validation {
    condition = contains(["beavis", "cheese", "cow", "daemon", "dragon", "fox", "ghostbusters", "kitty",
      "meow", "miki", "milk", "octopus", "pig", "stegosaurus", "stimpy", "trex",
    "turkey", "turtle", "tux"], var.character)
    error_message = "Invalid character!"
  }
}

variable "owner" {
  type = string
}

locals {
  lambda_runtime = "python3.12"
  lambda_environment = {
    CHARACTER = var.character
    GREETING  = ""
  }
}

data "archive_file" "cowsay" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  excludes    = ["test", "__init__.py"]
  output_path = "${path.module}/${local.product_name}.zip"
}

resource "aws_lambda_function" "cowsay" {
  filename         = data.archive_file.cowsay.output_path
  source_code_hash = data.archive_file.cowsay.output_base64sha256
  function_name    = "${var.owner}-${local.product_name}"
  role             = aws_iam_role.cowsay.arn
  handler          = "function.lambda_handler"
  runtime          = local.lambda_runtime
  environment {
    variables = local.lambda_environment
  }
  tags = local.tags
}

resource "aws_lambda_function_url" "cowsay" {
  function_name      = aws_lambda_function.cowsay.function_name
  authorization_type = "NONE"
}

output "function" {
  value = {
    name = aws_lambda_function.cowsay.function_name
    arn  = aws_lambda_function.cowsay.arn
    url  = aws_lambda_function_url.cowsay.function_url
    test = <<-EOT
    examples
    curl -X POST ${aws_lambda_function_url.cowsay.function_url} --data '{"message": "hi" }' -H "Content-Type: application/json" | jq .notice -r
    curl -X POST ${aws_lambda_function_url.cowsay.function_url} --data '{"message": "hi", "character": "${var.character}" }' -H "Content-Type: application/json" | jq .notice -r
    EOT
  }
}
