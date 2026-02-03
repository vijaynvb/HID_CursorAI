variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "serverless-web-app"
}

variable "region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

# Cognito Variables
variable "cognito_user_pool_name" {
  description = "Name of the Cognito User Pool"
  type        = string
  default     = "web-app-user-pool"
}

variable "cognito_user_pool_client_name" {
  description = "Name of the Cognito User Pool Client"
  type        = string
  default     = "web-app-client"
}

# Amplify Variables
variable "amplify_app_name" {
  description = "Name of the Amplify App"
  type        = string
  default     = "web-app"
}

variable "amplify_repository" {
  description = "Repository URL for Amplify (GitHub, GitLab, etc.)"
  type        = string
  default     = ""
}

variable "amplify_branch_name" {
  description = "Branch name for Amplify deployment"
  type        = string
  default     = "main"
}

# Lambda Variables
variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "appsync-resolver"
}

variable "lambda_runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "python3.11"
}

variable "lambda_handler" {
  description = "Lambda handler function"
  type        = string
  default     = "index.handler"
}

variable "lambda_zip_path" {
  description = "Path to Lambda function zip file"
  type        = string
  default     = "lambda_function.zip"
}

# AppSync Variables
variable "appsync_api_name" {
  description = "Name of the AppSync API"
  type        = string
  default     = "web-app-api"
}

variable "appsync_schema_file" {
  description = "Path to GraphQL schema file"
  type        = string
  default     = "schema.graphql"
}

# DynamoDB Variables
variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  type        = string
  default     = "app-data"
}

variable "dynamodb_hash_key" {
  description = "DynamoDB table hash key"
  type        = string
  default     = "id"
}

variable "dynamodb_billing_mode" {
  description = "DynamoDB billing mode (PROVISIONED or PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "dynamodb_read_capacity" {
  description = "DynamoDB read capacity units (if PROVISIONED)"
  type        = number
  default     = 5
}

variable "dynamodb_write_capacity" {
  description = "DynamoDB write capacity units (if PROVISIONED)"
  type        = number
  default     = 5
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "ServerlessWebApp"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
