import json
import wrapper
import os
import os_function
from opensearchpy import OpenSearch, helpers
from opensearchpy.helpers import bulk


def load_data():
    with open('/opt/python/full_format_recipes.json', 'r') as f:
        data = json.load(f)
        for recipe in data:
            yield {'_index': 'recipes', '_source': recipe}

def lambda_handler(event, context):
    print(f"Event: {json.dumps(event)}")
    
    password = wrapper.get_password()
    client = os_function.connect(password)

    # Specify the index and document type
    index_name = 'recipes'
    doc_type = '_doc'
    counter = 0

    response_body = ""
    status_code = 0
    # Create index in opensearch
    if event['action'] == 'create':
        try:
            response_body = os_function.create(client, index_name)
            print('Create Response: ', response_body)
            status_code = 200
        except Exception as e:
            print("Create error occurred:", str(e))
            status_code = 500
            response_body = str(e)
            
    # Load items into opensearch
    elif event['action'] == 'load':
        try:
            response_body = bulk(client, load_data())
            print('Load Response: ', response_body)
            status_code = 200
        except Exception as e:
            print("Load error occurred:", str(e))
            status_code = 500
            response_body = str(e)

    # Confirm number of items loaded into opensearch
    elif event['action'] == 'count':
        try:
            response_body = client.count(index=index_name)
            print(f"Total items in index '{index_name}': {response_body['count']}")
            status_code = 200
        except Exception as e:
            print("Load error occurred:", str(e))
            status_code = 500
            response_body = str(e)

    # Construct the response
    response = {
        'statusCode': status_code,
        'body': json.dumps(response_body),
        'headers': {
            'Content-Type': 'application/json'
        }
    }

    return response