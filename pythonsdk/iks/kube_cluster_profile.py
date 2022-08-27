"""
    Module to create Kubernetes Cluster Profile
"""
import intersight.api.kubernetes_api as iksApi
from intersight.model.kubernetes_cluster_profile import KubernetesClusterProfile
from intersight.model.ippool_pool_relationship import IppoolPoolRelationship
from intersight.model.kubernetes_cluster_management_config \
    import KubernetesClusterManagementConfig
from intersight.model.kubernetes_sys_config_policy_relationship \
    import KubernetesSysConfigPolicyRelationship
from intersight.model.kubernetes_network_policy_relationship \
    import KubernetesNetworkPolicyRelationship
import logging

log = logging.getLogger(__name__)


def create_cluster(api_client, org_rel, var_data, moid_data):
    """
    Function to create Kubernetes Cluster Profile
    """
    ip_pool_rel = IppoolPoolRelationship(
        class_id = "mo.MoRef",
        object_type = "ippool.Pool",
        # moid = ippool_moid,
        moid = moid_data['ippool_moid']
        # selector = "$filter=Name eq 'pysdk_demo'"
    )

    mgmt_config = KubernetesClusterManagementConfig(
        load_balancer_count = var_data['profile']['lb_count'],
        ssh_keys = [var_data['profile']['ssh_keys']]
    )

    net_config_rel = KubernetesNetworkPolicyRelationship(
        class_id = "mo.MoRef",
        object_type = "kubernetes.NetworkPolicy",
        moid = moid_data['net_policy_moid'],
        # selector = "$filter=Name eq 'pysdk_demo'"
    )

    sys_config_rel = KubernetesSysConfigPolicyRelationship(
        class_id = "mo.MoRef",
        object_type = "kubernetes.SysConfigPolicy",
        moid = moid_data['sys_config_moid'],
        # selector = "$filter=Name eq 'pysdk_demo'"
    )

    kubernetes_cluster_profile = KubernetesClusterProfile(
        class_id = "kubernetes.ClusterProfile",
        object_type = "kubernetes.ClusterProfile",
        name = var_data['name'],
        description = var_data['description'],
        organization = org_rel,
        cluster_ip_pools = [ip_pool_rel],
        management_config = mgmt_config,
        sys_config = sys_config_rel,
        net_config = net_config_rel
        # trusted_registries (KubernetesTrustedRegistriesPolicyRelationship)
        # container_runtime_config (KubernetesContainerRuntimePolicyRelationship)
    )

    api_instance = iksApi.KubernetesApi(api_client)
    cluster_profile = api_instance.create_kubernetes_cluster_profile(kubernetes_cluster_profile)
    cluster_profile_moid = cluster_profile['moid']
    return cluster_profile_moid
