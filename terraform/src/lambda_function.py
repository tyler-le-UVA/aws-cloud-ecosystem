import json
import uuid
import os
import boto3

dynamodb = boto3.resource('dynamodb')
TABLE_NAME = os.environ.get('TABLE_NAME', 'user-ratings')

def lambda_handler(event, context):
    # DevOps trick: Log the raw incoming event so you can see it in CloudWatch
    print("Raw API Gateway Event:", event) 
    
    try:
        # Handle both Proxy Integration (stringified body) and Raw Integration (direct dict)
        if 'body' in event and isinstance(event['body'], str):
            body = json.loads(event['body'])
        else:
            body = event
            
        # Map the exact keys your React Native app / curl command will send
        album_name = body.get('album_name', 'unknown_album')
        artist = body.get('artist', 'unknown_artist')
        rating = body.get('rating', 0)
        user_id = body.get('user_id', 'unknown_user')
        
        record_id = str(uuid.uuid4())
        item = {
            'id': record_id,
            'user_id': user_id,
            'album_name': album_name,
            'artist': artist,
            'rating': int(rating)
        }
        
        table = dynamodb.Table(TABLE_NAME)
        table.put_item(Item=item)
        
        return {
            'statusCode': 201,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({'message': 'Rating logged successfully!', 'rating_id': record_id})
        }
        
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Internal Server Error'})
        }