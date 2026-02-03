"""
Lambda function handler for AppSync resolver
This is a sample Lambda function that can be used with AppSync
"""

import json
import os
import boto3
from datetime import datetime

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb')
table_name = os.environ.get('DYNAMODB_TABLE')
table = dynamodb.Table(table_name) if table_name else None


def handler(event, context):
    """
    Lambda handler function
    
    Args:
        event: Event data from AppSync or other trigger
        context: Lambda context object
    
    Returns:
        Response dictionary
    """
    try:
        # Log the incoming event
        print(f"Received event: {json.dumps(event)}")
        
        # Extract operation type from event
        operation = event.get('operation', 'GET')
        
        if operation == 'GET':
            # Get item by ID
            item_id = event.get('id')
            if not item_id:
                return {
                    'statusCode': 400,
                    'body': json.dumps({'error': 'Missing id parameter'})
                }
            
            response = table.get_item(Key={'id': item_id})
            
            if 'Item' in response:
                return {
                    'statusCode': 200,
                    'body': json.dumps(response['Item'])
                }
            else:
                return {
                    'statusCode': 404,
                    'body': json.dumps({'error': 'Item not found'})
                }
        
        elif operation == 'PUT':
            # Create or update item
            item_id = event.get('id')
            name = event.get('name')
            description = event.get('description', '')
            
            if not item_id or not name:
                return {
                    'statusCode': 400,
                    'body': json.dumps({'error': 'Missing required parameters: id, name'})
                }
            
            item = {
                'id': item_id,
                'name': name,
                'description': description,
                'updatedAt': datetime.utcnow().isoformat()
            }
            
            # Check if item exists
            existing = table.get_item(Key={'id': item_id})
            if 'Item' not in existing:
                item['createdAt'] = datetime.utcnow().isoformat()
            
            table.put_item(Item=item)
            
            return {
                'statusCode': 200,
                'body': json.dumps(item)
            }
        
        elif operation == 'DELETE':
            # Delete item
            item_id = event.get('id')
            if not item_id:
                return {
                    'statusCode': 400,
                    'body': json.dumps({'error': 'Missing id parameter'})
                }
            
            response = table.delete_item(Key={'id': item_id})
            
            return {
                'statusCode': 200,
                'body': json.dumps({'message': 'Item deleted successfully'})
            }
        
        elif operation == 'LIST':
            # List all items
            limit = event.get('limit', 100)
            
            response = table.scan(Limit=limit)
            
            return {
                'statusCode': 200,
                'body': json.dumps({
                    'items': response.get('Items', []),
                    'count': len(response.get('Items', []))
                })
            }
        
        else:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': f'Unsupported operation: {operation}'})
            }
    
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
