import json
from opensearchpy import OpenSearch, helpers
from opensearchpy.helpers import bulk

client = OpenSearch(
    hosts=["https://search-opensearch-engine-auap362x237qm4go42cvfmrqh4.us-east-1.es.amazonaws.com/"],
    http_auth=("opensearch-masteruser", ")9oo!14}lvIQ&kZ:!J4D%D{Ul<D<Z6{Y"),
    use_ssl=True,
    verify_certs=False,
    ssl_assert_hostname=False,
    ssl_show_warn=False,
)
client.info()

resp = client.search(
    index="recipes",
    body={
        "query": {
            "match_all": {}
        },
    },
    size=5
)

# Retrieve the selected documents from the response
selected_documents = resp['hits']['hits']

# Print the selected documents
for doc in selected_documents:
    print(doc['_source'])
