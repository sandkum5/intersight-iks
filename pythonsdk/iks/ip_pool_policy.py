"""
    Module to create an IP Pool Policy
    Return ippool_moid
"""
# from intersight.api.ippool_api import ApiClient
from intersight.api.ippool_api import IppoolApi
from intersight.model.ippool_pool import IppoolPool
from intersight.model.ippool_ip_v4_block import IppoolIpV4Block
from intersight.model.ippool_ip_v4_config import IppoolIpV4Config
from intersight.model.ippool_ip_v6_block import IppoolIpV6Block
from intersight.model.ippool_ip_v6_config import IppoolIpV6Config
import logging

log = logging.getLogger(__name__)


def create_ippool(api_client, org_rel, var_data):
    """
    Function to create an IP Pool Policy
    """
    v4_block = IppoolIpV4Block(
        _from = var_data['ippool']['v4_from'],
        size = var_data['ippool']['v4_size']
    )

    v4_config = IppoolIpV4Config(
        netmask = var_data['ippool']['v4_netmask'],
        gateway = var_data['ippool']['v4_gateway'],
        primary_dns = var_data['ippool']['v4_pri_dns'],
        secondary_dns = var_data['ippool']['v4_sec_dns']
    )

    v6_block = IppoolIpV6Block(
        _from = var_data['ippool']['v6_from'],
        size = var_data['ippool']['v6_size']
    )

    v6_config = IppoolIpV6Config(
        gateway = var_data['ippool']['v6_gateway'],
        prefix = var_data['ippool']['v6_prefix'],
        primary_dns = var_data['ippool']['v6_pri_dns'],
        secondary_dns = var_data['ippool']['v6_sec_dns']
    )

    ippool_pool = IppoolPool(
        name = var_data['name'],
        description = var_data['description'],
        organization = org_rel,
        ip_v4_blocks = [v4_block],
        ip_v4_config = v4_config,
        ip_v6_blocks = [],
        ip_v6_config = v6_config
    )

    # ippool_api_client = ApiClient(configuration)
    # api_instance = IppoolApi(api_client=ippool_api_client)
    api_instance = IppoolApi(api_client)
    create_ippool = api_instance.create_ippool_pool(ippool_pool)
    ippool_moid = create_ippool['moid']
    return ippool_moid
