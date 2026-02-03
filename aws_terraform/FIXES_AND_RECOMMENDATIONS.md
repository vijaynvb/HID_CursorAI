# Quick Fix Guide - Terraform Configuration Improvements

This document provides specific code changes to address the issues identified in the validation report.

---

## Priority 1: Security Enhancements

### 1. Enable MFA for Cognito User Pool

**File:** `main.tf`  
**Location:** `aws_cognito_user_pool.main` resource

**Current Code:**
```hcl
mfa_configuration = "OFF"
```

**Recommended Fix:**
```hcl
mfa_configuration = "OPTIONAL"  # or "ON" for mandatory MFA

software_token_mfa_configuration {
  enabled = true
}
```

**Reference:** [AWS Cognito MFA Configuration](https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-mfa.html)

---

### 2. Enable Deletion Protection for Cognito

**File:** `main.tf`  
**Location:** `aws_cognito_user_pool.main` resource

**Add after line 70:**
```hcl
deletion_protection = "ACTIVE"
```

**Complete updated resource:**
```hcl
resource "aws_cognito_user_pool" "main" {
  name = "${var.project_name}-${var.cognito_user_pool_name}"

  deletion_protection = "ACTIVE"  # Add this line

  # ... rest of configuration
}
```

---

### 3. Configure Account Recovery Settings

**File:** `main.tf`  
**Location:** `aws_cognito_user_pool.main` resource

**Add after deletion_protection:**
```hcl
account_recovery_setting {
  recovery_mechanism {
    name     = "verified_email"
    priority = 1
  }
  recovery_mechanism {
    name     = "verified_phone_number"
    priority = 2
  }
}
```

---

## Priority 2: Operational Improvements

### 4. Enable AppSync CloudWatch Logging

**File:** `main.tf`  
**Location:** After `aws_appsync_graphql_api.main` resource

**Add new resource:**
```hcl
resource "aws_appsync_graphql_api" "main" {
  # ... existing configuration ...
  
  # Add logging configuration
  log_config {
    cloudwatch_logs_role_arn = aws_iam_role.appsync_logs_role.arn
    field_log_level         = "ALL"  # Options: NONE, ERROR, ALL
  }
}

# Add IAM role for AppSync logging
resource "aws_iam_role" "appsync_logs_role" {
  name = "${var.project_name}-appsync-logs-role"

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
}

resource "aws_iam_role_policy" "appsync_logs_policy" {
  name = "${var.project_name}-appsync-logs-policy"
  role = aws_iam_role.appsync_logs_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${var.region}:*:*"
      }
    ]
  })
}
```

---

### 5. Configure Lambda Dead Letter Queue

**File:** `main.tf`  
**Location:** `aws_lambda_function.main` resource

**Add SQS queue and update Lambda:**
```hcl
# Add SQS Dead Letter Queue
resource "aws_sqs_queue" "lambda_dlq" {
  name                      = "${var.project_name}-lambda-dlq"
  message_retention_seconds = 1209600  # 14 days

  tags = {
    Name = "${var.project_name}-lambda-dlq"
  }
}

# Update Lambda function to include DLQ
resource "aws_lambda_function" "main" {
  # ... existing configuration ...
  
  dead_letter_config {
    target_arn = aws_sqs_queue.lambda_dlq.arn
  }
  
  # ... rest of configuration ...
}

# Add IAM policy for Lambda to send to DLQ
resource "aws_iam_role_policy" "lambda_dlq_policy" {
  name = "${var.project_name}-lambda-dlq-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:SendMessage"
        ]
        Resource = aws_sqs_queue.lambda_dlq.arn
      }
    ]
  })
}
```

---

## Priority 3: Complete Schema Implementation

### 6. Add Missing AppSync Resolvers

**File:** `main.tf`  
**Location:** After existing resolvers

**Add listItems resolver:**
```hcl
resource "aws_appsync_resolver" "list_items_resolver" {
  api_id      = aws_appsync_graphql_api.main.id
  type        = "Query"
  field       = "listItems"
  data_source = aws_appsync_datasource.dynamodb.name

  request_template = <<EOF
{
  "version": "2017-02-28",
  "operation": "Scan",
  #if($ctx.args.limit)
    "limit": $util.toJson($ctx.args.limit),
  #end
  #if($ctx.args.nextToken)
    "nextToken": $util.toJson($ctx.args.nextToken),
  #end
}
EOF

  response_template = <<EOF
{
  "items": $util.toJson($ctx.result.items),
  "nextToken": #if($ctx.result.nextToken)"$ctx.result.nextToken"#else null #end
}
EOF
}
```

**Add deleteItem resolver:**
```hcl
resource "aws_appsync_resolver" "delete_item_resolver" {
  api_id      = aws_appsync_graphql_api.main.id
  type        = "Mutation"
  field       = "deleteItem"
  data_source = aws_appsync_datasource.dynamodb.name

  request_template = <<EOF
{
  "version": "2017-02-28",
  "operation": "DeleteItem",
  "key": {
    "id": $util.dynamodb.toDynamoDBJson($ctx.args.id)
  }
}
EOF

  response_template = <<EOF
$util.toJson($ctx.result)
EOF
}
```

---

## Priority 4: Additional Enhancements

### 7. Add DynamoDB Streams (if needed)

**File:** `main.tf`  
**Location:** Update both DynamoDB table resources

**Add to both `main_provisioned` and `main_on_demand`:**
```hcl
stream_enabled   = true
stream_view_type = "NEW_AND_OLD_IMAGES"
```

**Add Lambda event source mapping:**
```hcl
resource "aws_lambda_event_source_mapping" "dynamodb_stream" {
  event_source_arn  = local.dynamodb_table.stream_arn
  function_name     = aws_lambda_function.main.arn
  starting_position = "LATEST"
  
  # Optional: batch size and other settings
  batch_size = 10
}
```

---

### 8. Add Amplify Custom Domain (Optional)

**File:** `main.tf`  
**Location:** After `aws_amplify_branch.main`

**Add custom domain resource:**
```hcl
resource "aws_amplify_domain_association" "main" {
  app_id      = aws_amplify_app.main.id
  domain_name = "your-domain.com"

  sub_domain {
    branch_name = aws_amplify_branch.main.branch_name
    prefix      = "www"
  }

  sub_domain {
    branch_name = aws_amplify_branch.main.branch_name
    prefix      = ""  # Root domain
  }

  wait_for_verification = false
}
```

**Note:** Requires domain verification and SSL certificate setup.

---

### 9. Add WAF for Cognito Protection (Advanced)

**File:** `main.tf`  
**Location:** After Cognito resources

**Add WAF Web ACL:**
```hcl
resource "aws_wafv2_web_acl" "cognito_protection" {
  name        = "${var.project_name}-cognito-waf"
  description = "WAF for Cognito User Pool protection"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CommonRuleSetMetric"
      sampled_requests_enabled    = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project_name}-cognito-waf"
    sampled_requests_enabled   = true
  }

  tags = {
    Name = "${var.project_name}-cognito-waf"
  }
}

# Associate with Cognito User Pool (requires AWS API call or separate resource)
```

**Reference:** [AWS WAF Documentation](https://docs.aws.amazon.com/waf/)

---

## Implementation Order

1. **Security (Critical):**
   - Enable MFA
   - Enable deletion protection
   - Configure account recovery

2. **Operational (High):**
   - Enable AppSync logging
   - Configure Lambda DLQ

3. **Completeness (Medium):**
   - Add missing resolvers
   - Complete schema implementation

4. **Enhancements (Low):**
   - DynamoDB Streams (if needed)
   - Custom domain
   - WAF protection

---

## Testing After Changes

After implementing fixes, run:

```bash
# Validate Terraform syntax
terraform validate

# Format code
terraform fmt

# Review changes
terraform plan

# Apply changes
terraform apply
```

---

## Additional Resources

- [AWS Cognito Best Practices](https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-security-best-practices.html)
- [AWS Lambda Error Handling](https://docs.aws.amazon.com/lambda/latest/dg/invocation-retries.html)
- [AWS AppSync Logging](https://docs.aws.amazon.com/appsync/latest/devguide/monitoring.html)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
