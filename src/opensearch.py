import json
from opensearchpy import OpenSearch, helpers
from opensearchpy.helpers import bulk

def load_data():
    with open('full_format_recipes.json', 'r') as f:
        data = json.load(f)
        for recipe in data:
            yield {'_index': 'recipes', '_source': recipe}

client = OpenSearch(
    hosts=["https://search-opensearch-engine-auap362x237qm4go42cvfmrqh4.us-east-1.es.amazonaws.com/"],
    http_auth=("opensearch-masteruser", ")9oo!14}lvIQ&kZ:!J4D%D{Ul<D<Z6{Y"),
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
#response = client.indices.create(index_name)



# Call load data to bulk load file into opensearch
# bulk(client, load_data())

# Confirm number of items loaded into opensearch
response = client.count(index=index_name)
print(f"Total items in index '{index_name}': {response['count']}")


