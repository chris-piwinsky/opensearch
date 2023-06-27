import os
from opensearchpy import OpenSearch, helpers
from opensearchpy.helpers import bulk

def connect(password):
    client = OpenSearch(
        hosts=[os.environ['OS_URI']],
        http_auth=(os.environ['MASTER_USER'], password),
        use_ssl=True,
        verify_certs=False,
        ssl_assert_hostname=False,
        ssl_show_warn=False,
    )
    client.info()
    return client

def create(client, index_name):
    client.indices.create(index_name)
