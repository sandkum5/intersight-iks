#!/usr/bin/env python3
"""
    Expand IKS Cluster Tasks
    - Load Balancer Count
    - Update Control Plane Node Configuration
        Desired size
        Min size
        Max size
    - Add Worker Node Pool *
    - Update Worker Node Counts
        Desired size
        Min Size
        Max Size
    - Add Addon's
"""
import yaml
import iks
import logging
import intersight.api.kubernetes_api as iksApi

log = logging.getLogger(__name__)


def read_yaml(var_filename):
    """
    Function to get Variable Data
    """
    with open(var_filename, encoding='utf8') as file:
        var_data = yaml.safe_load(file)
    return var_data


def main():
    """
    Function to Update Kubernetes Profile
    """
    # Get Variable Data
    cluster_name = 'pysdk_demo'

    # Create api_client
    var_data = read_yaml('variables.yml')
    key_id = var_data['api_key']
    private_key_path = var_data['secret_key']
    api_client = iks.get_api_client(key_id, private_key_path)

    update_data = read_yaml('update_vars.yaml')
    moid_data = read_yaml('moids.yaml')

    # Initialize API Instance
    api_instance = iksApi.KubernetesApi(api_client)

    # Get Organization relationship
    org_name = var_data['org_name'] # 'default'
    org_rel = iks.get_org_rel(api_client, org_name)

    # Get IKS Cluster Profile Moid
    # iks_cluster_info = iks.get_iks_cluster_info(api_client, cluster_name)
    # iks_profile_moid = iks_cluster_info['moid']

    # Update IKS Cluster Profile Loadbalancer Count
    print("Updating LB Count")
    iks_profile_moid = moid_data['cluster_profile_moid']
    iks_profile_info = iks.update_iks_profile(api_client, iks_profile_moid, update_data)

    # Update CP Node Group Profile
    print("Updating Control Plane Node Group")
    cp_ng_profile_moid = moid_data['cp_node_group_moid']
    cp_ng_profile = iks.update_cp_node_group_profile(api_client, cp_ng_profile_moid, update_data)

    # Update Worker Node Group Profile
    print("Updating Worker Node Group")
    worker_ng_profile_moid = moid_data['worker_node_group_moid']
    worker_ng_profile = iks.update_worker_node_group_profile(api_client, worker_ng_profile_moid, update_data)

    # Create Kubernetes Addon Policy
    print("Create Kubernetes Addon Policies")
    addon_moid_list = []
    addon_moids = iks.create_addon_policy(iks, api_client, org_rel, var_data, addon_moid_list)
    for moid in addon_moids:
        moid_data['addon_moid_list'].append(moid)

    # Create Kubernetes Cluster Addon Profile
    if addon_moids:
        print("Update Kubernetes Cluster Addon Profile")
        cluster_addon_info = iks.update_cluster_addon(api_client, org_rel, var_data, update_data, moid_data, addon_moid_list)

    with open('moids.yaml', 'w', encoding='utf8') as file:
        yaml.dump(moid_data, file)


if __name__ == '__main__':
    main()
