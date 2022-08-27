"""
    Module to create Kubernetes SysConfig Policy
"""
import intersight.api.kubernetes_api as iksApi
from intersight.model.kubernetes_sys_config_policy import KubernetesSysConfigPolicy
import logging

log = logging.getLogger(__name__)


def create_sys_config(api_client, org_rel, var_data):
    """
    Function to create Kubernetes Sys Config Policy
    """
    kubernetes_sys_config_policy = KubernetesSysConfigPolicy(
        name = var_data['name'],
        description = var_data['description'],
        organization = org_rel,
        dns_domain_name = var_data['sys_config']['dns_domain_name'],
        dns_servers = var_data['sys_config']['dns_servers'],
        ntp_servers = var_data['sys_config']['ntp_servers'],
        timezone = var_data['sys_config']['timezone']
    )

    api_instance = iksApi.KubernetesApi(api_client)
    sys_config = api_instance.create_kubernetes_sys_config_policy(kubernetes_sys_config_policy)
    sys_config_moid = sys_config['moid']
    return sys_config_moid
