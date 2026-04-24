import boto3 
ec2_instance = boto3.clinet('ec2', region_name= "us-east-1")
responce = ec2_0nstance.run_instances(
    ImageId = 'ami-0c94855ba95c71c99',
    InstanceType = 't2.micro',
)
print(responce) 