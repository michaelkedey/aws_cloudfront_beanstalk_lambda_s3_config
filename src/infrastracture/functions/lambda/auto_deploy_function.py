import os
import boto3
import time

def lambda_handler(event, context):
    eb_application_name = os.environ['EB_APPLICATION_NAME']
    eb_environment_name = os.environ['EB_ENVIRONMENT_NAME']
    s3_bucket_name = os.environ['S3_BUCKET_NAME']
    code_suffix = os.environ['CODE_SUFFIX']
    code_prefix = os.environ['CODE_PREFIX']

    s3 = boto3.client('s3')
    eb = boto3.client('elasticbeanstalk')

    for record in event['Records']:
        key = record['s3']['object']['key']

        if not (key.startswith(code_prefix) and key.endswith(code_suffix)):
            print(f'Object with key {key} does not match the required prefix and file type. Skipping deployment.')
            continue

        local_file_path = f'/tmp/{key}'
        s3.download_file(s3_bucket_name, key, local_file_path)

        version_label = str(int(time.time()))

        response = eb.create_application_version(
            ApplicationName=eb_application_name,
            VersionLabel=version_label,
            Description=f'Application version for {version_label}',
            SourceBundle={'S3Bucket': s3_bucket_name, 'S3Key': key},
        )

        response = eb.update_environment(
            ApplicationName=eb_application_name,
            EnvironmentName=eb_environment_name,
            VersionLabel=version_label,
        )

        print(f'Deployment initiated with version label {version_label} for file {key}: {response}')

        os.remove(local_file_path)

    return {
        'statusCode': 200,
        'body': 'Deployment initiated successfully!'
    }


# import os
# import boto3
# import time  # Added for generating a unique version label

# def lambda_handler(event, context):
#     # Get environment variables
#     eb_application_name = os.environ['EB_APPLICATION_NAME']
#     eb_environment_name = os.environ['EB_ENVIRONMENT_NAME']
#     s3_bucket_name = os.environ['S3_BUCKET_NAME']
#     code_suffix = os.environ['CODE_SUFFIX']
#     code_prefix = os.environ['CODE_PREFIX']

#     # Create an S3 client
#     s3 = boto3.client('s3')

#     # Create an Elastic Beanstalk client
#     eb = boto3.client('elasticbeanstalk')

#     # Iterate through each record in the event (S3 trigger)
#     for record in event['Records']:
#         # Get the key (file path) of the S3 object
#         key = record['s3']['object']['key']

#         # Check if the key has a prefix of "code_" and is a .zip file
#         if not (key.startswith(code_prefix) and key.endswith(code_suffix)):
#             print(f'Object with key {key} does not match the required prefix and file type. Skipping deployment.')
#             continue

#         # Download the file from S3 to /tmp directory in Lambda
#         local_file_path = f'/tmp/{key}'
#         s3.download_file(s3_bucket_name, key, local_file_path)

#         # Generate a unique version label based on the current timestamp
#         version_label = str(int(time.time()))

#         # Create a new application version
#         response = eb.create_application_version(
#             ApplicationName=eb_application_name,
#             VersionLabel=version_label,
#             Description=f'Application version for {version_label}',
#             SourceBundle={'S3Bucket': s3_bucket_name, 'S3Key': key},
#         )

#         # Update the environment to use the new application version
#         response = eb.update_environment(
#             ApplicationName=eb_application_name,
#             EnvironmentName=eb_environment_name,
#             VersionLabel=version_label,
#         )

#         # Print the deployment response
#         print(f'Deployment initiated with version label {version_label} for file {key}: {response}')

#         # Optionally, you can delete the file from /tmp after processing
#         os.remove(local_file_path)

#     return {
#         'statusCode': 200,
#         'body': 'Deployment initiated successfully!'
#     }
