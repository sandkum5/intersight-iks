"""
    Module to create Kubernetes Addon Policy
    Return Addon Policy Moid
"""
import intersight.api.kubernetes_api as iksApi
from intersight.model.kubernetes_addon_policy import KubernetesAddonPolicy
from intersight.model.kubernetes_addon_configuration import KubernetesAddonConfiguration
from intersight.model.kubernetes_addon_definition_relationship \
    import KubernetesAddonDefinitionRelationship
import logging

log = logging.getLogger(__name__)

def create_addon(api_client, org_rel, var_data):
    """
    Function to Create Kubernetes Addon Policy
    """
    api_instance = iksApi.KubernetesApi(api_client)
    addon_defs = api_instance.get_kubernetes_addon_definition_list(
        inlinecount = "allpages",
        skip = 0,
        top = 10,
        filter = "(Labels ne 'Essential' and Labels ne 'EOL' and \
            Labels ne 'Deprecated' and Labels ne 'TechPreview')"
    ).results

    addon_def_list = [addon['name'] for addon in addon_defs]

    print("Available Addon Definition Name options: ")
    for addon in addon_def_list:
        print(addon)

    while True:
        addon_name = input("Enter Addon from above list: ")
        if addon_name in addon_def_list:
            break

    for addon in addon_defs:
        if addon['name'] == addon_name:
            addon_moid = addon['moid']

    if addon_moid:
        kube_addon_def_relationship = KubernetesAddonDefinitionRelationship(
            class_id = 'mo.MoRef',
            object_type = 'kubernetes.AddonDefinition',
            moid = addon_moid
        )

        kube_addon_config = KubernetesAddonConfiguration(
            overrides = var_data['addon']['overrides'],
            install_strategy = var_data['addon']['install_strategy'],
            upgrade_strategy = var_data['addon']['upgrade_strategy'],
            release_namespace = var_data['addon']['release_namespace']
        )

        kubernetes_addon_policy = KubernetesAddonPolicy(
            name = input("Enter Addon Name: "), # addon_name,
            description = var_data['description'],
            organization = org_rel,
            addon_configuration = kube_addon_config,
            addon_definition = kube_addon_def_relationship
        )

        addon_policy = api_instance.create_kubernetes_addon_policy(kubernetes_addon_policy)
        addon_policy_moid = addon_policy['moid']
        return addon_policy_moid
    return ""


def create_addon_policy(iks, api_client, org_rel, var_data, addon_moid_list):
    print("")
    addon_moid_list = addon_moid_list
    create_addon = (input("Do you want to create an addon policy y/n? ")).lower()
    if create_addon == 'y':
        addon_moid = iks.create_addon(api_client, org_rel, var_data)
        if addon_moid:
            addon_moid_list.append(addon_moid)
            print("Addon Policy created successfully!")
            iks.create_addon_policy(iks, api_client, org_rel, var_data, addon_moid_list)
    return addon_moid_list
