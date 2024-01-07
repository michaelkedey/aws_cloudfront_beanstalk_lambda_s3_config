# import os
# import boto3
# import time

# def lambda_handler(event, context):
#     eb_application_name = os.environ['EB_APPLICATION_NAME']
#     eb_environment_name = os.environ['EB_ENVIRONMENT_NAME']
#     s3_bucket_name = os.environ['S3_BUCKET_NAME']
#     code_suffix = os.environ['CODE_SUFFIX']
#     code_prefix = os.environ['CODE_PREFIX']

#     s3 = boto3.client('s3')
#     eb = boto3.client('elasticbeanstalk')

#     for record in event['Records']:
#         key = record['s3']['object']['key']

#         if not (key.startswith(code_prefix) and key.endswith(code_suffix)):
#             print(f'Object with key {key} does not match the required prefix and file type. Skipping deployment.')
#             continue

#         local_file_path = f'/tmp/{key}'
#         s3.download_file(s3_bucket_name, key, local_file_path)

#         version_label = str(int(time.time()))

#         response = eb.create_application_version(
#             ApplicationName=eb_application_name,
#             VersionLabel=version_label,
#             Description=f'Application version for {version_label}',
#             SourceBundle={'S3Bucket': s3_bucket_name, 'S3Key': key},
#         )

#         response = eb.update_environment(
#             ApplicationName=eb_application_name,
#             EnvironmentName=eb_environment_name,
#             VersionLabel=version_label,
#         )

#         print(f'Deployment initiated with version label {version_label} for file {key}: {response}')

#         os.remove(local_file_path)

#     return {
#         'statusCode': 200,
#         'body': 'Deployment initiated successfully!'
#     }



import os
import boto3
import time
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):

  # Validate environment variables
  required_envs = ['EB_APPLICATION_NAME', 'EB_ENVIRONMENT_NAME', 'S3_BUCKET_NAME', 'AWS_REGION']
  for env_var in required_envs:
    if not os.environ.get(env_var):
      raise Exception(f'{env_var} environment variable is required')  

  eb_application = os.environ['EB_APPLICATION_NAME']
  eb_environment = os.environ['EB_ENVIRONMENT_NAME']
  s3_bucket = os.environ['S3_BUCKET_NAME']
  aws_region = os.environ['AWS_REGION']

  # Create clients
  s3 = boto3.client('s3', region_name=aws_region)
  eb = boto3.client('elasticbeanstalk', region_name=aws_region)

  # Process S3 records
  for record in event['Records']:
    key = record['s3']['object']['key']

    # Validate filename 
    if not key.startswith('code_') and key.endswith('.zip'):
      logger.info(f'Invalid file {key} skipped')
      continue

    local_path = f'/tmp/{key}'

    try:
      # Download file 
      s3.download_file(s3_bucket, key, local_path)

      # Create new version
      version = create_application_version(eb, eb_application, key, s3_bucket)
      
      # Deploy version
      deploy_version(eb, eb_application, eb_environment, version)
    
    except Exception as e:
      logger.error(f'Error processing {key}', exc_info=True)
    
    finally:
      # Clean up temp file
      os.remove(local_path)

  return 'Done'
       
def create_application_version(eb, app_name, file_key, bucket):
   version = str(int(time.time()))
   resp = eb.create_application_version(
        ApplicationName=app_name,
        VersionLabel=version,
        SourceBundle={
            'S3Bucket': bucket,
            'S3Key': file_key
        }
    )
   return version

def deploy_version(eb, app_name, env_name, version):
  eb.update_environment(
        ApplicationName=app_name,
        EnvironmentName=env_name,
        VersionLabel=version
  )