# 1. Provision the HTTP API
resource "aws_apigatewayv2_api" "http_api" {
  name          = "duple-music-api"
  protocol_type = "HTTP"
}

# 2. Wire the API to your Lambda function
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.api_handler.invoke_arn
  integration_method = "POST"
}

# 3. Define the POST /rate routing path
resource "aws_apigatewayv2_route" "post_rate_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /rate"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# 4. Auto-deploy to the default stage
resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

# 5. Security Checkpoint: Explicitly grant API Gateway permission to trigger Lambda
resource "aws_lambda_permission" "api_gw_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_handler.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

# 6. Print the final deployment URL to the terminal
output "api_endpoint" {
  description = "The public URL to send POST requests to"
  value       = "${aws_apigatewayv2_api.http_api.api_endpoint}/rate"
}