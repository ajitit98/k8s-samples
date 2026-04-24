import boto3  # Import the boto3 library to interact with AWS services

# Set dry_run to True for testing (no actual deletions), False to perform deletions
dry_run = True  # Change to False only after verifying the lists

# Create an EC2 client using boto3
ec2 = boto3.client('ec2')

# Step 1: Get all running EC2 instances
# This retrieves instances that are currently in the 'running' state
running_instances = ec2.describe_instances(Filters=[{'Name': 'instance-state-name', 'Values': ['running']}])

# Initialize a set to store volume IDs that are attached to running instances
attached_volumes = set()

# Loop through each reservation and instance to collect attached volume IDs
for reservation in running_instances['Reservations']:
    for instance in reservation['Instances']:
        # Check block device mappings for EBS volumes attached to the instance
        for attachment in instance.get('BlockDeviceMappings', []):
            if 'Ebs' in attachment and 'VolumeId' in attachment['Ebs']:
                attached_volumes.add(attachment['Ebs']['VolumeId'])

# Step 2: Get all EBS volumes in the account
volumes = ec2.describe_volumes()

# Initialize a list to store unattached volumes (available and not attached to any instance)
unattached_volumes = []

# Loop through all volumes and filter those that are available and not attached
for volume in volumes['Volumes']:
    if volume['VolumeId'] not in attached_volumes and volume['State'] == 'available':
        unattached_volumes.append(volume)

# Step 3: Get all snapshots owned by the account
snapshots = ec2.describe_snapshots(OwnerIds=['self'])

# Get all AMIs owned by the account to check which snapshots are in use
images = ec2.describe_images(Owners=['self'])

# Initialize a set to store snapshot IDs that are used by AMIs
used_snapshots = set()

# Loop through AMIs and collect snapshot IDs used in their block device mappings
for image in images['Images']:
    for mapping in image.get('BlockDeviceMappings', []):
        if 'Ebs' in mapping and 'SnapshotId' in mapping['Ebs']:
            used_snapshots.add(mapping['Ebs']['SnapshotId'])

# Initialize a list to store unused snapshots (not used by any AMI)
unused_snapshots = []

# Loop through all snapshots and filter those not in use
for snapshot in snapshots['Snapshots']:
    if snapshot['SnapshotId'] not in used_snapshots:
        unused_snapshots.append(snapshot)

# Step 4: List unattached volumes
print("Unattached volumes:")
for vol in unattached_volumes:
    print(f"Volume ID: {vol['VolumeId']}, Size: {vol['Size']} GB")

# Step 5: List unused snapshots
print("Unused snapshots:")
for snap in unused_snapshots:
    print(f"Snapshot ID: {snap['SnapshotId']}, Volume ID: {snap.get('VolumeId', 'N/A')}, Size: {snap['VolumeSize']} GB")

# Step 6: Delete unattached volumes and unused snapshots if not in dry run mode
if not dry_run:
    # Delete unattached volumes
    for vol in unattached_volumes:
        ec2.delete_volume(VolumeId=vol['VolumeId'])
        print(f"Deleted volume {vol['VolumeId']}")
    # Delete unused snapshots
    for snap in unused_snapshots:
        ec2.delete_snapshot(SnapshotId=snap['SnapshotId'])
        print(f"Deleted snapshot {snap['SnapshotId']}")
else:
    print("Dry run mode: No deletions performed. Set dry_run = False to actually delete.") 