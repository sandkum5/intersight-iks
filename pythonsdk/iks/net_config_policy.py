"""
    Module to create Kubernetes Network Config Policy
    Return created policy Moid
"""
import intersight.api.kubernetes_api as iksApi
from intersight.model.kubernetes_network_policy import KubernetesNetworkPolicy
import logging

log = logging.getLogger(__name__)


def create_net_config(api_client, org_rel, var_data):
    """
    Function to create Kubernetes Network Config Policy
    """
    network_config_policy = KubernetesNetworkPolicy(
        name = var_data['name'],
        description = var_data['description'],
        organization = org_rel,
        pod_network_cidr = var_data['network_config']['pod_network_cidr'],
        service_cidr = var_data['network_config']['service_cidr']
        # cluster_profiles ([KubernetesClusterProfileRelationship])
        # tags ([MoTag])
    )

    api_instance = iksApi.KubernetesApi(api_client)
    network_policy = api_instance.create_kubernetes_network_policy(network_config_policy)
    net_policy_moid = network_policy['moid']
    return net_policy_moid
