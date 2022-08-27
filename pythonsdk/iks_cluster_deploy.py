#!/usr/bin/env python3
"""
    Deploy IKS Cluster profile if Undeployed or Pending-changes
"""
import time
import yaml
import iks
import logging

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
    Function to Deploy Kubernetes Policies and Profile
    """
    # Get Variable Data
    action = 'Deploy'  # Deploy, Unassign

    var_data = read_yaml('variables.yml')
    cluster_name = var_data['name']

    # Create api_client
    key_id = var_data['api_key']
    private_key_path = var_data['secret_key']
    api_client = iks.get_api_client(key_id, private_key_path)

    # Deploy IKS Cluster
    iks_cluster_info = iks.get_iks_cluster_info(api_client, cluster_name)
    iks_cluster_moid = iks_cluster_info['moid']
    # Cluster Status: 'Undeployed', 'Configuring', 'Ready', 'DeployFailedTerminal'

    # Deploy if the IKS Cluster status is 'Undeployed'
    if iks_cluster_info['status'] == "Undeployed":
        try:
            iks_cluster_profile = iks.deploy_iks_cluster(api_client, iks_cluster_moid, action)
        except Exception as e:
            print(e)

        while True:
            iks_cluster_info = iks.get_iks_cluster_info(api_client, cluster_name)
            iks_profile_status = iks_cluster_info['status']
            print(f"IKS Cluster Deploy Status: {iks_profile_status}")
            time.sleep(60)
            if iks_profile_status == 'DeployFailedTerminal':
                print("IKS Cluster Deployment Failed!")
                break
            # if status == 'Deploy':
            if iks_profile_status == 'Ready':
                print("IKS Cluster Deployed Successfully!")
                break

    # Check if IKS Cluster profile status in Ready State
    if iks_cluster_info['status'] == "Ready":
        print("IKS Cluster Already Deployed!")

    # Deploy if the Config_state shows "Pending-changes"
    if iks_cluster_info['config_context']['config_state'] == "Pending-changes":
        try:
            iks_cluster_profile = iks.deploy_iks_cluster(api_client, iks_cluster_moid, action)
        except Exception as e:
            print(e)

        while True:
            iks_cluster_info = iks.get_iks_cluster_info(api_client, cluster_name)
            iks_profile_status = iks_cluster_info['status']
            print(f"IKS Cluster Deploy Status: {iks_profile_status}")
            time.sleep(60)
            if iks_profile_status == 'DeployFailedTerminal':
                print("IKS Cluster Deployment Failed!")
                break
            # if status == 'Deploy':
            if iks_profile_status == 'Ready':
                print("IKS Cluster Deployed Successfully!")
                break

    # Do nothing is the IKS Cluster profile is in Configuring state
    if iks_cluster_info['status'] == "Configuring":
        print("IKS Cluster State is Configuring, which means a change is in-progress")



if __name__ == '__main__':
    main()
