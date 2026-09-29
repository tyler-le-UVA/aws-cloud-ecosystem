# 1. Compress the local Python code for deployment
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/lambda.zip"
}

# 2. Define the base IAM Role for the Lambda function
resource "aws_iam_role" "lambda_exec_role" {
  name = "duple_lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# 3. Enforce Least Privilege: Allow writing ONLY to the specific DynamoDB table
resource "aws_iam_role_policy" "dynamodb_access" {
  name = "lambda_dynamodb_write"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "dynamodb:PutItem"
      ]
      Resource = aws_dynamodb_table.ratings_table.arn
    }]
  })
}

# 4. Attach standard policy to allow writing execution logs to CloudWatch
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# 5. Provision the Lambda function
resource "aws_lambda_function" "api_handler" {
  function_name    = "duple-create-rating"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  architectures    = ["x86_64"]

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.ratings_table.name
    }
  }
}