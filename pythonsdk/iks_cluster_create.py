#!/usr/bin/env python3
# Install Modules:
# pip install requests intersight intersight-auth
"""
    Import all the individual policy/profile modules
    Create Kubernetes policies and profiles
"""
import yaml
import iks
from intersight.model.organization_organization_relationship \
    import OrganizationOrganizationRelationship
import logging

log = logging.getLogger(__name__)


def get_var_data(var_filename):
    """
    Function to get Variable Data
    """
    with open(var_filename, encoding='utf8') as file:
        var_data = yaml.safe_load(file)
    return var_data


def main():
    """
    Function to create Kubernetes Policies and Profile
    """
    # Get Variable Data
    var_filename = 'variables.yml'
    var_data = get_var_data(var_filename)
    moid_data = {}
    # Create api_client
    key_id = var_data['api_key']
    private_key_path = var_data['secret_key']
    api_client = iks.get_api_client(key_id, private_key_path)

    # Get Organization relationship
    print("")
    print(f"Initializing {var_data['org_name']} Organization")
    org_name = var_data['org_name'] # 'default'
    org_rel = iks.get_org_rel(api_client, org_name)
    # print("Organization Relationship Object: ")
    # print(org_rel)
    print("")

    # Create IP Pool Policy
    print("Create IP Pool Policy")
    ippool_moid = iks.create_ippool(api_client, org_rel, var_data)
    moid_data['ippool_moid'] = ippool_moid
    print("")

    # Create Network Config Policy
    print("Create Kubernetes Network Config Policy")
    net_policy_moid = iks.create_net_config(api_client, org_rel, var_data)
    moid_data['net_policy_moid'] = net_policy_moid
    print("")

    # Create SysConfig Policy
    print("Create Kubernetes SysConfig Policy")
    sys_config_moid = iks.create_sys_config(api_client, org_rel, var_data)
    moid_data['sys_config_moid'] = sys_config_moid
    print("")

    # Create Kubernetes Version Policy
    print("Create Kubernetes Version Policy")
    kube_version_moid = iks.create_kube_version(api_client, org_rel, var_data)
    moid_data['kube_version_moid'] = kube_version_moid
    print("")

    # Create Kubernetes Addon Policy
    print("Create Kubernetes Addon Policies")

    # def create_addon_policy(api_client, org_rel, var_data, addon_moid_list):
    #     print("")
    #     create_addon = (input("Do you want to create an addon policy y/n? ")).lower()
    #     if create_addon == 'y':
    #         addon_moid = iks.create_addon(api_client, org_rel, var_data)
    #         if addon_moid:
    #             addon_moid_list.append(addon_moid)
    #             print("Addon Policy created successfully!")
    #             create_addon_policy(api_client, org_rel, var_data, addon_moid_list)
    #     return addon_moid_list


    addon_moid_list = []
    addon_moid_list = iks.create_addon_policy(iks, api_client, org_rel, var_data, addon_moid_list)
    moid_data['addon_moid_list'] = addon_moid_list

    # Create VM Infra Config Policy
    print("")
    print("Create Kubernetes VM Infra Config Policy")
    vm_infra_config_moid = iks.create_vm_infra_config(api_client, org_rel, var_data)
    moid_data['vm_infra_config_moid'] = vm_infra_config_moid
    print("")

    # Create VM Instance Policy
    # print("")
    print("Create Kubernetes VM Instance Policy")
    vm_instance_moid = iks.create_vm_instance(api_client, org_rel, var_data)
    moid_data['vm_instance_moid'] = vm_instance_moid
    print("")

    # Create Kubernetes Cluster Profile
    # print("")
    print("Create Kubernetes Cluster Profile")
    cluster_profile_moid = iks.create_cluster(api_client, org_rel, var_data, moid_data)
    moid_data['cluster_profile_moid'] = cluster_profile_moid
    print("")

    # Create Kubernetes Control Plane Node Group Profile
    # print("")
    print("Create Kubernetes Control Plane Node Group Profile")
    cp_node_group_moid = iks.create_cp_node_group(api_client, org_rel, var_data, moid_data)
    moid_data['cp_node_group_moid'] = cp_node_group_moid
    print("")

    # Create Kubernetes Control Plane VM Infra Provider
    # print("")
    print("Create Kubernetes Control Plane VM Infra Provider")
    cp_vm_infra_provider_moid = iks.create_cp_vm_infra_provider(
        api_client, org_rel, var_data, moid_data
    )
    moid_data['cp_vm_infra_provider_moid'] = cp_vm_infra_provider_moid
    print("")

    # Create Kubernetes Worker Node Group Profile
    # print("")
    print("Create Kubernetes Worker Node Group Profile")
    worker_node_group_moid = iks.create_worker_node_group(api_client, org_rel, var_data, moid_data)
    moid_data['worker_node_group_moid'] = worker_node_group_moid
    print("")

    # Create Kubernetes Worker VM Infra Provider
    # print("")
    print("Create Kubernetes Worker VM Infra Provider")
    worker_vm_infra_provider_moid = iks.create_worker_vm_infra_provider(
        api_client, org_rel, var_data, moid_data
    )
    moid_data['worker_vm_infra_provider_moid'] = worker_vm_infra_provider_moid
    print("")

    # Create Kubernetes Cluster Addon Profile
    if moid_data['addon_moid_list']:
        print("Create Kubernetes Cluster Addon Profile")
        cluster_addon_moid = iks.create_cluster_addon(api_client, org_rel, var_data, moid_data)
        moid_data['cluster_addon_moid'] = cluster_addon_moid
        print("")

    with open('moids.yaml', 'a', encoding='utf8') as file:
        yaml.dump(moid_data, file)
    print("Writing Moid Data to moids.yaml file")
    print("")


if __name__ == '__main__':
    main()
