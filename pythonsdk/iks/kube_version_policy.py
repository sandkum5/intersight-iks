"""
    Module to create Kubernetes Version Policy
"""
import intersight.api.kubernetes_api as iksApi
# from intersight.model.kubernetes_version import KubernetesVersion
from intersight.model.kubernetes_version_relationship import KubernetesVersionRelationship
from intersight.model.kubernetes_version_policy import KubernetesVersionPolicy
import logging

log = logging.getLogger(__name__)


def create_kube_version(api_client, org_rel, var_data):
    """
    Function to create Kubernetes Version Policy
    """
    api_instance = iksApi.KubernetesApi(api_client)
    get_kube_versions = api_instance.get_kubernetes_version_list(
        inlinecount = 'allpages',
        skip = 0,
        top = 10,
        filter = "not(Tags/any(t:t/Key eq 'intersight.profile.SolutionOwnerType' or \
        (t/Key eq 'intersight.kubernetes.SupportStatus' and \
        t/Value in ('Unsupported', 'Deprecated', 'UpgradeRequired'))))"
    ).results

    # kube_versions = [version['kubernetes_version'] for version in get_kube_versions]
    kube_versions = [version['name'] for version in get_kube_versions]
    print('Available Kubernetes Versions are: ')
    for k_version in kube_versions:
        print(k_version)
    while True:
        version = input("Enter Kubernetes Version from above list: ")
        if version in kube_versions:
            break

    for kube_version in get_kube_versions:
        # if version == kube_version['kubernetes_version']:
        if version == kube_version['name']:
            # kube_version_name = kube_version['name']
            # kube_version = kube_version['kubernetes_version']
            kube_version_moid = kube_version['moid']

    kube_version_relationship = KubernetesVersionRelationship(
        class_id = 'mo.MoRef',
        object_type = 'kubernetes.Version',
        # kubernetes_version = kube_version,
        moid = kube_version_moid
    )

    kubernetes_version_policy = KubernetesVersionPolicy(
        name = var_data['name'],
        description = var_data['description'],
        organization = org_rel,
        version = kube_version_relationship
    )

    kubernetes_version = api_instance.create_kubernetes_version_policy(kubernetes_version_policy)
    kube_version_policy_moid = kubernetes_version['moid']
    return kube_version_policy_moid
