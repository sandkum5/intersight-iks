"""
    Module to Update Kubernetes Cluster Profile
"""
import intersight.api.kubernetes_api as iksApi
from intersight.model.kubernetes_cluster_profile \
    import KubernetesClusterProfile
from intersight.model.kubernetes_cluster_management_config \
    import KubernetesClusterManagementConfig

def update_iks_profile(api_client, iks_profile_moid, var_data):
    """
    Update Load Balancer Count in IKS Cluster Profile
    """
    api_instance = iksApi.KubernetesApi(api_client)

    mgmt_config = KubernetesClusterManagementConfig(
        load_balancer_count = var_data['profile']['lb_count'],
        ssh_keys = [var_data['profile']['ssh_keys']]
    )

    kubernetes_cluster_profile = KubernetesClusterProfile(
        class_id = "kubernetes.ClusterProfile",
        object_type = "kubernetes.ClusterProfile",
        management_config = mgmt_config
    )

    iks_profile = api_instance.update_kubernetes_cluster_profile(iks_profile_moid, kubernetes_cluster_profile)
    return iks_profile
