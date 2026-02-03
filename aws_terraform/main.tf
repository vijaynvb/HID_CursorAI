terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = merge(
      var.tags,
      {
        Project     = var.project_name
        Environment = var.environment
      }
    )
  }
}

# Local values for conditional configuration
locals {
  # Check if DynamoDB should use provisioned capacity
  use_provisioned_capacity = var.dynamodb_billing_mode == "PROVISIONED"
  
  # Reference to the correct DynamoDB table based on billing mode
  dynamodb_table = local.use_provisioned_capacity ? aws_dynamodb_table.main_provisioned[0] : aws_dynamodb_table.main_on_demand[0]
}

# ============================================================================
# Amazon Cognito - User Authentication
# ============================================================================

resource "aws_cognito_user_pool" "main" {
  name = "${var.project_name}-${var.cognito_user_pool_name}"

  # Password policy
  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_uppercase = true
    require_numbers   = true
    require_symbols   = true
  }

  # User attributes
  schema {
    name                = "email"
    attribute_data_type = "String"
    required            = true
    mutable             = true
  }

  schema {
    name                = "name"
    attribute_data_type = "String"
    required            = false
    mutable             = true
  }

  # Auto-verify email
  auto_verified_attributes = ["email"]

  # MFA configuration
  mfa_configuration = "OFF"

  tags = {
    Name = "${var.project_name}-user-pool"
  }
}

resource "aws_cognito_user_pool_client" "main" {
  name         = "${var.project_name}-${var.cognito_user_pool_client_name}"
  user_pool_id = aws_cognito_user_pool.main.id

  generate_secret                      = false
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  supported_identity_providers         = ["COGNITO"]

  callback_urls = [
    "http://localhost:3000",
    "https://localhost:3000"
  ]

  logout_urls = [
    "http://localhost:3000",
    "https://localhost:3000"
  ]

  prevent_user_existence_errors = "ENABLED"
}

resource "aws_cognito_identity_pool" "main" {
  identity_pool_name               = "${var.project_name}-identity-pool"
  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.main.id
    provider_name           = aws_cognito_user_pool.main.endpoint
    server_side_token_check = false
  }

  tags = {
    Name = "${var.project_name}-identity-pool"
  }
}

# ============================================================================
# DynamoDB - Data Storage
# ============================================================================

# DynamoDB table - Provisioned capacity version
resource "aws_dynamodb_table" "main_provisioned" {
  count = local.use_provisioned_capacity ? 1 : 0

  name           = "${var.project_name}-${var.dynamodb_table_name}"
  billing_mode   = "PROVISIONED"
  read_capacity  = var.dynamodb_read_capacity
  write_capacity = var.dynamodb_write_capacity
  hash_key       = var.dynamodb_hash_key

  attribute {
    name = var.dynamodb_hash_key
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }

  tags = {
    Name = "${var.project_name}-dynamodb-table"
  }

  lifecycle {
    prevent_destroy = false
  }
}

# DynamoDB table - Pay per request version
resource "aws_dynamodb_table" "main_on_demand" {
  count        = local.use_provisioned_capacity ? 0 : 1
  name         = "${var.project_name}-${var.dynamodb_table_name}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = var.dynamodb_hash_key

  attribute {
    name = var.dynamodb_hash_key
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }

  tags = {
    Name = "${var.project_name}-dynamodb-table"
  }

  lifecycle {
    prevent_destroy = false
  }
}


# ============================================================================
# AWS Lambda - Serverless Compute
# ============================================================================

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-lambda-role"
  }
}

# IAM Policy for Lambda to access DynamoDB
resource "aws_iam_role_policy" "lambda_dynamodb_policy" {
  name = "${var.project_name}-lambda-dynamodb-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = [
          local.dynamodb_table.arn,
          "${local.dynamodb_table.arn}/index/*"
        ]
      }
    ]
  })
}

# IAM Policy for Lambda basic execution
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# IAM Policy for Lambda to invoke AppSync
resource "aws_iam_role_policy" "lambda_appsync_policy" {
  name = "${var.project_name}-lambda-appsync-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "appsync:GraphQL"
        ]
        Resource = [
          "${aws_appsync_graphql_api.main.arn}/*"
        ]
      }
    ]
  })
}

# Lambda Function
resource "aws_lambda_function" "main" {
  filename         = var.lambda_zip_path
  function_name    = "${var.project_name}-${var.lambda_function_name}"
  role            = aws_iam_role.lambda_role.arn
  handler         = var.lambda_handler
  runtime         = var.lambda_runtime
  timeout         = 30
  memory_size     = 256

  # Environment variables
  environment {
    variables = {
      DYNAMODB_TABLE = local.dynamodb_table.name
      APPSYNC_API_ID = aws_appsync_graphql_api.main.id
    }
  }

  tags = {
    Name = "${var.project_name}-lambda-function"
  }

  # Create a dummy zip if file doesn't exist (for initial setup)
  depends_on = [aws_iam_role_policy.lambda_dynamodb_policy]
}

# ============================================================================
# AWS AppSync - GraphQL API
# ============================================================================

resource "aws_appsync_graphql_api" "main" {
  authentication_type = "AMAZON_COGNITO_USER_POOLS"
  name                = "${var.project_name}-${var.appsync_api_name}"

  user_pool_config {
    aws_region     = var.region
    user_pool_id   = aws_cognito_user_pool.main.id
    default_action = "ALLOW"
  }

  schema = file("${path.module}/${var.appsync_schema_file}")

  tags = {
    Name = "${var.project_name}-appsync-api"
  }
}

# AppSync Data Source for DynamoDB
resource "aws_appsync_datasource" "dynamodb" {
  api_id           = aws_appsync_graphql_api.main.id
  name             = "${var.project_name}-dynamodb-datasource"
  service_role_arn = aws_iam_role.appsync_datasource_role.arn
  type             = "AMAZON_DYNAMODB"

  dynamodb_config {
    table_name = local.dynamodb_table.name
    region     = var.region
  }
}

# IAM Role for AppSync Data Source
resource "aws_iam_role" "appsync_datasource_role" {
  name = "${var.project_name}-appsync-datasource-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "appsync.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-appsync-datasource-role"
  }
}

# IAM Policy for AppSync to access DynamoDB
resource "aws_iam_role_policy" "appsync_dynamodb_policy" {
  name = "${var.project_name}-appsync-dynamodb-policy"
  role = aws_iam_role.appsync_datasource_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = [
          local.dynamodb_table.arn,
          "${local.dynamodb_table.arn}/index/*"
        ]
      }
    ]
  })
}

# AppSync Resolver (example - Query resolver)
resource "aws_appsync_resolver" "query_resolver" {
  api_id      = aws_appsync_graphql_api.main.id
  type        = "Query"
  field       = "getItem"
  data_source = aws_appsync_datasource.dynamodb.name

  request_template = <<EOF
{
  "version": "2017-02-28",
  "operation": "GetItem",
  "key": {
    "id": $util.dynamodb.toDynamoDBJson($ctx.args.id)
  }
}
EOF

  response_template = <<EOF
$util.toJson($ctx.result)
EOF
}

# AppSync Resolver (example - Mutation resolver)
resource "aws_appsync_resolver" "mutation_resolver" {
  api_id      = aws_appsync_graphql_api.main.id
  type        = "Mutation"
  field       = "putItem"
  data_source = aws_appsync_datasource.dynamodb.name

  request_template = <<EOF
{
  "version": "2017-02-28",
  "operation": "PutItem",
  "key": {
    "id": $util.dynamodb.toDynamoDBJson($ctx.args.id)
  },
  "attributeValues": $util.dynamodb.toMapValuesJson($ctx.args)
}
EOF

  response_template = <<EOF
$util.toJson($ctx.result)
EOF
}

# ============================================================================
# AWS Amplify - Frontend Hosting
# ============================================================================

resource "aws_amplify_app" "main" {
  name       = "${var.project_name}-${var.amplify_app_name}"
  repository = var.amplify_repository

  # Build specification
  build_spec = <<-EOT
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - npm install
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: dist
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

  # Environment variables
  environment_variables = {
    REACT_APP_COGNITO_USER_POOL_ID     = aws_cognito_user_pool.main.id
    REACT_APP_COGNITO_CLIENT_ID        = aws_cognito_user_pool_client.main.id
    REACT_APP_APPSYNC_GRAPHQL_ENDPOINT = aws_appsync_graphql_api.main.uris["GRAPHQL"]
    REACT_APP_REGION                   = var.region
  }

  # Enable auto branch creation
  enable_auto_branch_creation = false

  # Enable branch auto build
  enable_branch_auto_build = true

  # Enable branch auto deletion
  enable_branch_auto_deletion = false

  tags = {
    Name = "${var.project_name}-amplify-app"
  }
}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.main.id
  branch_name = var.amplify_branch_name

  # Enable auto build
  enable_auto_build = true

  # Environment variables
  environment_variables = {
    REACT_APP_COGNITO_USER_POOL_ID     = aws_cognito_user_pool.main.id
    REACT_APP_COGNITO_CLIENT_ID        = aws_cognito_user_pool_client.main.id
    REACT_APP_APPSYNC_GRAPHQL_ENDPOINT = aws_appsync_graphql_api.main.uris["GRAPHQL"]
    REACT_APP_REGION                   = var.region
  }

  tags = {
    Name = "${var.project_name}-amplify-branch"
  }
}
