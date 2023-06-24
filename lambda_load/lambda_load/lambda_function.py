import json
import boto3
import os
from opensearchpy import OpenSearch, helpers
from opensearchpy.helpers import bulk


def load_data():
    with open('full_format_recipes.json', 'r') as f:
        data = json.load(f)
        for recipe in data:
            yield {'_index': 'recipes', '_source': recipe}


def get_password():
    ssm = boto3.client('ssm')
    parameter = ssm.get_parameter(Name=os.environ['SSM_PARAMETER'], WithDecryption=True)
    print(parameter['Parameter']['Value'])
    return parameter['Parameter']['Value']


def lambda_handler(event, context):
    password = get_password()
    client = OpenSearch(
        hosts=[os.environ['OS_URI']],
        http_auth=(os.environ['MASTER_USER'], password),
        use_ssl=True,
        verify_certs=False,
        ssl_assert_hostname=False,
        ssl_show_warn=False,
    )
    client.info()

    # Specify the index and document type
    index_name = 'recipes'
    doc_type = '_doc'
    counter = 0

    # Create index in opensearch
    response = client.indices.create(index_name)

    # Call load data to bulk load file into opensearch
    # bulk(client, load_data())

    # Confirm number of items loaded into opensearch
    # response = client.count(index=index_name)
    # print(f"Total items in index '{index_name}': {response['count']}")
