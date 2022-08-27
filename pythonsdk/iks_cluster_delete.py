#!/usr/bin/env python3
"""
    Module to delete Kubernetes Cluster and policies
"""
import os
import time
import yaml
import intersight.api.kubernetes_api as iksApi
from intersight.api.ippool_api import IppoolApi
import iks
import logging

log = logging.getLogger(__name__)


def read_yaml(var_filename):
    """
    Function to get Variable data
    """
    with open(var_filename, encoding='utf8') as file:
        var_data = yaml.safe_load(file)
    return var_data


def get_policy_moids(policy_names):
    if policy_names.get('addon_policy'):
        api_instance.delete_kubernetes_addon_policy(policy_names['addon_policy'])


def delete_policies(api_instance, ippool_instance, moid_data):
    """
    Function to delete Kubernetes policies
    """
    if moid_data['addon_moid_list']:
        for moid in moid_data['addon_moid_list']:
            print("Delete Addon Policies")
            try:
                api_instance.delete_kubernetes_addon_policy(moid)
            except Exception as e:
                print("Failed")
                continue

    if moid_data['kube_version_moid']:
        print("Delete Kubernetes Version Policy")
        try:
            api_instance.delete_kubernetes_version_policy(moid_data['kube_version_moid'])
        except Exception as e:
            print("Failed")

    if moid_data['net_policy_moid']:
        print("Delete Network Policy")
        try:
            api_instance.delete_kubernetes_network_policy(moid_data['net_policy_moid'], async_req=True)
        except Exception as e:
            print("Failed")

    if moid_data['sys_config_moid']:
        print("Delete SysConfig Policy")
        try:
            api_instance.delete_kubernetes_sys_config_policy(moid_data['sys_config_moid'])
        except Exception as e:
            print("Failed")

    if moid_data['vm_infra_config_moid']:
        print("Delete VM Infrastructure Config Policy")
        try:
            api_instance.delete_kubernetes_virtual_machine_infra_config_policy(moid_data['vm_infra_config_moid'])
        except Exception as e:
            print("Failed")

    if moid_data['vm_instance_moid']:
        print("Delete VM Instance Policy")
        try:
            api_instance.delete_kubernetes_virtual_machine_instance_type(moid_data['vm_instance_moid'])
        except Exception as e:
            print("Failed")

    if moid_data['ippool_moid']:
        print("Delete IP Pool Policy")
        try:
            ippool_instance.delete_ippool_pool(moid_data['ippool_moid'])
        except Exception as e:
            print("Failed")

    # api_instance.delete_kubernetes_cluster_addon_profile(moid_data['cluster_addon_moid'])
    # api_instance.delete_kubernetes_node_group_profile(moid_data['cp_node_group_moid'])
    # api_instance.delete_kubernetes_node_group_profile(moid_data['worker_node_group_moid'])
    return None


def remove_moids(moid_data):
    """
    Function to remove Moid's from the moids.yaml file
    """
    policy_names = ['cluster_profile_moid', 'addon_moid_list', 'kube_version_moid', 'net_policy_moid', 'sys_config_moid', 'vm_infra_config_moid', 'vm_instance_moid', 'ippool_moid', 'cluster_addon_moid', 'cp_node_group_moid', 'cp_vm_infra_provider_moid', 'worker_node_group_moid', 'worker_vm_infra_provider_moid']
    if moid_data:
        for name in policy_names:
            moid_data.pop(name)
        print("Moid's deleted successfully from moids.yaml file!")


def main():
    """
    Function to delete Kubernetes Cluster and policies
    """
    # Get Variable Data
    var_data = read_yaml('variables.yml')

    if os.path.exists('moids.yaml'):
        moid_data = read_yaml('moids.yaml')
    else:
        moid_data = ""
        print("The moids.yaml file doesn't exist!")

    cluster_name = var_data['name']

    # Get API Client
    key_id = var_data['api_key']
    private_key_path = var_data['secret_key']
    api_client = iks.get_api_client(key_id, private_key_path)

    # Initialize Instances
    ippool_instance = IppoolApi(api_client)
    api_instance = iksApi.KubernetesApi(api_client)

    # Delete IKS Profile
    iks_profile_list = api_instance.get_kubernetes_cluster_profile_list(filter=f"Name eq '{cluster_name}'")
    if iks_profile_list['results']:
        iks_cluster_moid = api_instance.get_kubernetes_cluster_profile_list(filter=f"Name eq '{cluster_name}'").results[0]['moid']
        try:
            api_instance.delete_kubernetes_cluster_profile(iks_cluster_moid)
        except Exception as e:
            print(e)

    while True:
        try:
            data = api_instance.get_kubernetes_cluster_profile_by_moid(
                iks_cluster_moid
            )
            time.sleep(5)
            print(f"{data['status']} IKS Cluster")
        except Exception as _exception:
            # print(_exception)
            break

    if moid_data:
        # Delete Kubernetes Policies
        delete_policies(api_instance, ippool_instance, moid_data)

        # Delete Moid's from variables.yml file
        remove_moids(moid_data)

    if os.path.exists('moids.yaml'):
        os.remove('moids.yaml')

    # moid_data = ''
    # with open('moids.yaml', 'w', encoding='utf8') as file:
    #     yaml.dump(moid_data, file)


if __name__ == '__main__':
    main()
