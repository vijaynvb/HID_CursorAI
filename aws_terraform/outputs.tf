# ============================================================================
# Cognito Outputs
# ============================================================================

output "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  value       = aws_cognito_user_pool.main.id
}

output "cognito_user_pool_arn" {
  description = "Cognito User Pool ARN"
  value       = aws_cognito_user_pool.main.arn
}

output "cognito_user_pool_client_id" {
  description = "Cognito User Pool Client ID"
  value       = aws_cognito_user_pool_client.main.id
}

output "cognito_identity_pool_id" {
  description = "Cognito Identity Pool ID"
  value       = aws_cognito_identity_pool.main.id
}

output "cognito_user_pool_endpoint" {
  description = "Cognito User Pool endpoint"
  value       = aws_cognito_user_pool.main.endpoint
}

# ============================================================================
# DynamoDB Outputs
# ============================================================================

output "dynamodb_table_name" {
  description = "DynamoDB table name"
  value       = local.dynamodb_table.name
}

output "dynamodb_table_arn" {
  description = "DynamoDB table ARN"
  value       = local.dynamodb_table.arn
}

# ============================================================================
# Lambda Outputs
# ============================================================================

output "lambda_function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.main.function_name
}

output "lambda_function_arn" {
  description = "Lambda function ARN"
  value       = aws_lambda_function.main.arn
}

output "lambda_function_invoke_arn" {
  description = "Lambda function invoke ARN"
  value       = aws_lambda_function.main.invoke_arn
}

# ============================================================================
# AppSync Outputs
# ============================================================================

output "appsync_api_id" {
  description = "AppSync API ID"
  value       = aws_appsync_graphql_api.main.id
}

output "appsync_api_arn" {
  description = "AppSync API ARN"
  value       = aws_appsync_graphql_api.main.arn
}

output "appsync_graphql_endpoint" {
  description = "AppSync GraphQL endpoint"
  value       = aws_appsync_graphql_api.main.uris["GRAPHQL"]
}

output "appsync_realtime_endpoint" {
  description = "AppSync Realtime endpoint"
  value       = aws_appsync_graphql_api.main.uris["REALTIME"]
}

# ============================================================================
# Amplify Outputs
# ============================================================================

output "amplify_app_id" {
  description = "Amplify App ID"
  value       = aws_amplify_app.main.id
}

output "amplify_app_arn" {
  description = "Amplify App ARN"
  value       = aws_amplify_app.main.arn
}

output "amplify_app_default_domain" {
  description = "Amplify App default domain"
  value       = aws_amplify_app.main.default_domain
}

output "amplify_branch_id" {
  description = "Amplify Branch ID"
  value       = aws_amplify_branch.main.id
}

# ============================================================================
# Configuration Outputs
# ============================================================================

output "frontend_config" {
  description = "Frontend configuration values"
  value = {
    cognito_user_pool_id     = aws_cognito_user_pool.main.id
    cognito_client_id        = aws_cognito_user_pool_client.main.id
    appsync_graphql_endpoint = aws_appsync_graphql_api.main.uris["GRAPHQL"]
    region                   = var.region
  }
}
