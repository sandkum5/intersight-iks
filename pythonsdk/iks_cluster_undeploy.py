#!/usr/bin/env python3
"""
    Import all the individual policy/profile modules
    Create Kubernetes policies and profiles
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
    action = 'Undeploy'  # Deploy, Unassign

    var_data = read_yaml('variables.yml')
    cluster_name = var_data['name']

    # Create api_client
    key_id = var_data['api_key']
    private_key_path = var_data['secret_key']
    api_client = iks.get_api_client(key_id, private_key_path)

    # Deploy IKS Cluster
    iks_cluster_info = iks.get_iks_cluster_info(api_client, cluster_name)
    iks_cluster_moid = iks_cluster_info['moid']

    if iks_cluster_info['status'] == "Ready":
        try:
            iks_cluster_profile = iks.deploy_iks_cluster(api_client, iks_cluster_moid, action)
        except Exception as e:
            print(e)

    # Cluster Status: 'Undeployed', 'Configuring', 'Ready', 'DeployFailedTerminal', 'Undeploying'
    while True:
        iks_cluster_info = iks.get_iks_cluster_info(api_client, cluster_name)
        iks_profile_status = iks_cluster_info['status']
        print(f"Cluster Undeploy Status: {iks_profile_status}")
        if iks_profile_status == 'Undeploying':
            time.sleep(60)
        if iks_profile_status == 'DeployFailedTerminal':
            print("IKS Cluster Deployment in Failed State!")
            break
        if iks_profile_status == 'Undeployed':
            print("IKS Cluster Undeployed Successfully!")
            break

    # print(iks_cluster_profile)


if __name__ == '__main__':
    main()
