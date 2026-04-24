import boto3 
client = boto3.client('s3') 
response = client.create_bucket(
    ACL='private',
    Bucket='devops-001',
    CreateBucketConfiguration={'LocationConstraint': 'us-west-2'},)
