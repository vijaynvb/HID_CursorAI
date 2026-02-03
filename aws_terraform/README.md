# AWS Serverless Web Application - Terraform Configuration

This Terraform configuration provisions a complete serverless web application architecture on AWS, including:

- **Amazon Cognito** - User authentication and identity management
- **AWS Amplify** - Frontend hosting and CI/CD
- **AWS Lambda** - Serverless compute functions
- **AWS AppSync** - Managed GraphQL API
- **Amazon DynamoDB** - NoSQL database

## Architecture Overview

```
Users → AWS Amplify → Amazon Cognito (Auth)
                    ↓
                 AWS Lambda → AWS AppSync → GraphQL → DynamoDB
```

## Prerequisites

1. **AWS Account** with appropriate permissions
2. **Terraform** installed (version >= 1.0)
3. **AWS CLI** configured with credentials
4. **Python 3.11** (for Lambda function)

## Setup Instructions

### 1. Configure AWS Credentials

```bash
aws configure
```

Or set environment variables:
```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

### 2. Customize Variables

Copy the example variables file and update with your values:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your specific configuration:
- Update `amplify_repository` with your Git repository URL
- Adjust region, project name, and other settings as needed

### 3. Prepare Lambda Function

Create a zip file for the Lambda function:

```bash
# Create a directory for Lambda code
mkdir -p lambda_package
cp lambda_function.py lambda_package/index.py

# Install dependencies (if any)
cd lambda_package
pip install -r requirements.txt -t .

# Create zip file
zip -r ../lambda_function.zip .
cd ..
```

Or use the provided `lambda_function.py` directly by creating a simple zip:

```bash
zip lambda_function.zip lambda_function.py
```

### 4. Initialize Terraform

```bash
terraform init
```

### 5. Review the Plan

```bash
terraform plan
```

### 6. Apply the Configuration

```bash
terraform apply
```

Type `yes` when prompted to create the resources.

### 7. Get Output Values

After successful deployment, retrieve important values:

```bash
terraform output
```

Key outputs include:
- Cognito User Pool ID and Client ID
- AppSync GraphQL endpoint
- Amplify App ID and default domain
- DynamoDB table name

## Configuration Files

- **`main.tf`** - Main Terraform configuration with all AWS resources
- **`variables.tf`** - Input variables definition
- **`outputs.tf`** - Output values
- **`schema.graphql`** - GraphQL schema for AppSync API
- **`lambda_function.py`** - Sample Lambda function code
- **`terraform.tfvars.example`** - Example variables file

## Resource Details

### Amazon Cognito

- **User Pool**: Manages user accounts and authentication
- **User Pool Client**: Application client for user authentication
- **Identity Pool**: Provides AWS credentials for authenticated users

### AWS Amplify

- **App**: Main Amplify application
- **Branch**: Git branch for deployment (default: main)
- Configured with environment variables for Cognito and AppSync endpoints

### AWS Lambda

- **Function**: Serverless compute function
- **IAM Role**: Permissions for DynamoDB and AppSync access
- Configured with environment variables for table name and API ID

### AWS AppSync

- **GraphQL API**: Managed GraphQL API with Cognito authentication
- **Data Source**: DynamoDB data source
- **Resolvers**: Query and Mutation resolvers for GraphQL operations

### Amazon DynamoDB

- **Table**: NoSQL database table
- **Billing Mode**: PAY_PER_REQUEST (default) or PROVISIONED
- Point-in-time recovery enabled
- Server-side encryption enabled

## GraphQL Schema

The included `schema.graphql` provides:
- **Query**: `getItem`, `listItems`
- **Mutation**: `putItem`, `deleteItem`
- **Subscription**: `onItemUpdate`

## Frontend Integration

Use the output values to configure your frontend application:

```javascript
// Example React configuration
const config = {
  Auth: {
    region: 'us-east-1',
    userPoolId: '<COGNITO_USER_POOL_ID>',
    userPoolWebClientId: '<COGNITO_CLIENT_ID>',
  },
  aws_appsync_graphqlEndpoint: '<APPSYNC_GRAPHQL_ENDPOINT>',
  aws_appsync_region: 'us-east-1',
  aws_appsync_authenticationType: 'AMAZON_COGNITO_USER_POOLS',
};
```

## Updating Resources

To update resources:

```bash
terraform plan
terraform apply
```

## Destroying Resources

To remove all resources:

```bash
terraform destroy
```

**Warning**: This will delete all resources including data in DynamoDB. Make sure to backup important data first.

## Troubleshooting

### Lambda Function Not Found

If you get an error about the Lambda zip file not existing:
1. Create the `lambda_function.zip` file as described in step 3
2. Or update `lambda_zip_path` in `terraform.tfvars` to point to your zip file

### AppSync Schema Errors

If AppSync schema validation fails:
1. Check `schema.graphql` for syntax errors
2. Ensure all types referenced in resolvers are defined in the schema

### Amplify Repository Issues

If Amplify fails to connect to your repository:
1. Ensure the repository URL is correct
2. Configure repository access in AWS Amplify console
3. Or leave `amplify_repository` empty and connect manually later

## Cost Considerations

- **DynamoDB**: PAY_PER_REQUEST mode charges per request (recommended for low traffic)
- **Lambda**: Pay per invocation and compute time
- **AppSync**: Pay per API request
- **Amplify**: Pay for build minutes and hosting
- **Cognito**: Free tier includes 50,000 MAUs

## Security Best Practices

1. **Never commit** `terraform.tfvars` with sensitive data
2. Use **IAM roles** with least privilege
3. Enable **MFA** for Cognito in production
4. Use **VPC** endpoints for private resources if needed
5. Enable **CloudTrail** for audit logging
6. Regularly **rotate** access keys

## Additional Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS AppSync Documentation](https://docs.aws.amazon.com/appsync/)
- [AWS Amplify Documentation](https://docs.amplify.aws/)
- [Amazon Cognito Documentation](https://docs.aws.amazon.com/cognito/)

## License

This configuration is provided as-is for educational and development purposes.
