"""
    Module to create Control Plane Node Group Profile
"""
import intersight.api.kubernetes_api as iksApi
from intersight.model.kubernetes_node_group_profile import KubernetesNodeGroupProfile
from intersight.model.ippool_pool_relationship import IppoolPoolRelationship
from intersight.model.kubernetes_version_policy_relationship \
    import KubernetesVersionPolicyRelationship
from intersight.model.kubernetes_cluster_profile_relationship \
    import KubernetesClusterProfileRelationship
import logging

log = logging.getLogger(__name__)


def create_cp_node_group(api_client, org_rel, var_data, moid_data):
    """
    Function to create Control Plane Node Group Profile
    """
    api_instance = iksApi.KubernetesApi(api_client)
    kube_version_rel = KubernetesVersionPolicyRelationship(
        class_id = "mo.MoRef",
        object_type = "kubernetes.VersionPolicy",
        moid = moid_data['kube_version_moid']
        # selector = "$filter=Name eq 'pysdk_demo'"
    )

    ip_pool_rel = IppoolPoolRelationship(
        class_id = "mo.MoRef",
        object_type = "ippool.Pool",
        moid = moid_data['ippool_moid']
        # selector = "$filter=Name eq 'pysdk_demo'"
    )

    kubernetes_cluster_profile_rel = KubernetesClusterProfileRelationship(
        class_id = "mo.MoRef",
        object_type = "kubernetes.ClusterProfile",
        moid = moid_data['cluster_profile_moid']
    )

    kubernetes_node_group_profile = KubernetesNodeGroupProfile(
        node_type = var_data['cp_node_group']['node_type'],
        name = var_data['cp_node_group']['name'],
        desiredsize = var_data['cp_node_group']['desiredsize'],
        minsize = var_data['cp_node_group']['minsize'],
        maxsize = var_data['cp_node_group']['maxsize'],
        kubernetes_version = kube_version_rel,
        # labels = '', # ([KubernetesNodeGroupLabel])
        ip_pools = [ip_pool_rel],
        cluster_profile = kubernetes_cluster_profile_rel
    )

    cp_node_group_profile = api_instance.create_kubernetes_node_group_profile(
        kubernetes_node_group_profile
    )
    cp_node_group_moid = cp_node_group_profile['moid']
    return cp_node_group_moid
