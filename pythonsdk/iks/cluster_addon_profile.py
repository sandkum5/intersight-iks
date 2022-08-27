"""
    Module to create Kubernetes Cluster Addon Profile
"""
import intersight.api.kubernetes_api as iksApi
from intersight.model.kubernetes_cluster_addon_profile import KubernetesClusterAddonProfile
from intersight.model.kubernetes_addon import KubernetesAddon
from intersight.model.kubernetes_addon_configuration import KubernetesAddonConfiguration
from intersight.model.kubernetes_cluster_relationship import KubernetesClusterRelationship
from intersight.model.mo_mo_ref import MoMoRef


def create_cluster_addon(api_client, org_rel, var_data, moid_data):
    """
        Function to create Kubernetes Cluster Addon Profile
    """
    api_instance = iksApi.KubernetesApi(api_client)
    kubernetes_addon_config = KubernetesAddonConfiguration(
        overrides = var_data['cluster_addon']['overrides'],
        install_strategy = var_data['cluster_addon']['install_strategy'],
        upgrade_strategy = var_data['cluster_addon']['upgrade_strategy']
    )

    addon_list = []
    for key, addon_moid in enumerate(moid_data['addon_moid_list']):
        addon_api_data = api_instance.get_kubernetes_addon_policy_by_moid(addon_moid)
        addon_policy_mo_ref = MoMoRef(
            class_id = "mo.MoRef",
            object_type = "kubernetes.AddonPolicy",
            # moid = moid_data['addon_moid']
            moid = addon_moid
        )

        kubernetes_addon = KubernetesAddon(
            # name = f"{var_data['name']}-{key}",
            name = addon_api_data['name'],
            addon_configuration = kubernetes_addon_config,
            addon_policy = addon_policy_mo_ref
        )
        addon_list.append(kubernetes_addon)

    cluster_moid = api_instance.get_kubernetes_cluster_list(
        filter=f"Name eq '{var_data['name']}'"
    )['results'][0]['moid']

    kubernetes_cluster_rel = KubernetesClusterRelationship(
        class_id = "mo.MoRef",
        object_type = "kubernetes.Cluster",
        moid = cluster_moid
    )

    kubernetes_cluster_addon_profile = KubernetesClusterAddonProfile(
        name = var_data['name'],
        organization = org_rel,
        associated_cluster = kubernetes_cluster_rel,
        addons = addon_list
    )

    cluster_addon_profile = api_instance.create_kubernetes_cluster_addon_profile(
        kubernetes_cluster_addon_profile
    )
    cluster_addon_moid = cluster_addon_profile['moid']
    return cluster_addon_moid


def update_cluster_addon(api_client, org_rel, var_data, update_data, moid_data, addon_moid_list):
    """
        Function to Update Kubernetes Cluster Addon Profile
    """
    api_instance = iksApi.KubernetesApi(api_client)
    kubernetes_addon_config = KubernetesAddonConfiguration(
        overrides = update_data['cluster_addon']['overrides'],
        install_strategy = update_data['cluster_addon']['install_strategy'],
        upgrade_strategy = update_data['cluster_addon']['upgrade_strategy']
    )

    addon_list = []
    for key, addon_moid in enumerate(moid_data['addon_moid_list']):
        addon_api_data = api_instance.get_kubernetes_addon_policy_by_moid(addon_moid)
        addon_policy_mo_ref = MoMoRef(
            class_id = "mo.MoRef",
            object_type = "kubernetes.AddonPolicy",
            # moid = moid_data['addon_moid']
            moid = addon_moid
        )

        kubernetes_addon = KubernetesAddon(
            # name = f"{var_data['name']}-{key}",
            name = addon_api_data['name'],
            addon_configuration = kubernetes_addon_config,
            addon_policy = addon_policy_mo_ref
        )
        addon_list.append(kubernetes_addon)

    cluster_moid = api_instance.get_kubernetes_cluster_list(
        filter=f"Name eq '{var_data['name']}'"
    )['results'][0]['moid']

    kubernetes_cluster_rel = KubernetesClusterRelationship(
        class_id = "mo.MoRef",
        object_type = "kubernetes.Cluster",
        moid = cluster_moid
    )

    kubernetes_cluster_addon_profile = KubernetesClusterAddonProfile(
        name = var_data['name'],
        organization = org_rel,
        associated_cluster = kubernetes_cluster_rel,
        addons = addon_list
    )

    if moid_data['cluster_addon_moid']:
        cluster_addon_profile = api_instance.update_kubernetes_cluster_addon_profile(moid_data['cluster_addon_moid'], kubernetes_cluster_addon_profile)

    if !moid_data['cluster_addon_moid']:
        cluster_addon_profile = api_instance.create_kubernetes_cluster_addon_profile(
            kubernetes_cluster_addon_profile
        )

    return cluster_addon_profile['moid']
