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
