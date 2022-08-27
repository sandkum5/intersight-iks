"""
    Module to Update Worker Node Group Profile
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


def update_worker_node_group_profile(api_client, worker_ng_profile_moid, var_data):
    """
    Function to create Control Plane Node Group Profile
    """
    api_instance = iksApi.KubernetesApi(api_client)

    kubernetes_node_group_profile = KubernetesNodeGroupProfile(
        desiredsize = var_data['worker_node_group']['desiredsize'],
        minsize = var_data['worker_node_group']['minsize'],
        maxsize = var_data['worker_node_group']['maxsize']
    )

    worker_ng_profile = api_instance.update_kubernetes_node_group_profile(
        worker_ng_profile_moid,
        kubernetes_node_group_profile
    )

    return worker_ng_profile