import boto3
import os

def get_password():
    print('IN WRAPPER')
    ssm = boto3.client('ssm')
    parameter = ssm.get_parameter(Name=os.environ['SSM_PARAMETER'], WithDecryption=True)
    print(parameter['Parameter']['Value'])
    return parameter['Parameter']['Value']