"""
    Module to create Kubernetes Cluster Profile
"""
import yaml
from .intersight_api_client import get_api_client
import intersight.api.kubernetes_api as iksApi
from intersight.model.kubernetes_cluster_profile import KubernetesClusterProfile
import logging

log = logging.getLogger(__name__)


def get_iks_cluster_info(api_client, cluster_name):
    """
    Function to get IKS Cluster Moid
    """
    api_instance = iksApi.KubernetesApi(api_client)
    iks_cluster_data = api_instance.get_kubernetes_cluster_profile_list(filter=f"Name eq '{cluster_name}'").results[0]
    iks_cluster_info = {}
    iks_cluster_info['name'] = cluster_name
    iks_cluster_info['moid'] = iks_cluster_data['moid']
    iks_cluster_info['status'] = iks_cluster_data['status']
    iks_cluster_info['config_context'] = iks_cluster_data['config_context']
    return iks_cluster_info


def deploy_iks_cluster(api_client, iks_cluster_moid, action):
    """
    Function to Deploy Kubernetes Cluster Profile
    """
    kubernetes_cluster_profile = KubernetesClusterProfile(
        class_id = "kubernetes.ClusterProfile",
        object_type = "kubernetes.ClusterProfile",
        action = action
    )
    api_instance = iksApi.KubernetesApi(api_client)
    cluster_profile = api_instance.patch_kubernetes_cluster_profile(iks_cluster_moid, kubernetes_cluster_profile)
    return cluster_profile
