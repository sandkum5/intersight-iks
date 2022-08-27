"""
    Module to create Kubernetes VM Infra Config Policy
    Return Policy Moid
"""
import json
import intersight.api.kubernetes_api as iksApi
from intersight.model.kubernetes_virtual_machine_infra_config_policy \
    import KubernetesVirtualMachineInfraConfigPolicy
# from intersight.model.kubernetes_base_virtual_machine_infra_config \
#    import KubernetesBaseVirtualMachineInfraConfig
from intersight.model.kubernetes_esxi_virtual_machine_infra_config \
    import KubernetesEsxiVirtualMachineInfraConfig
from intersight.model.asset_device_registration_relationship \
    import AssetDeviceRegistrationRelationship
from intersight.api import virtualization_api
import logging

log = logging.getLogger(__name__)


def get_cluster_name(vmware_cluster_data):
    """
    Function to get VMware Cluster Name
    """
    print("Available VMware Cluster Names: ")
    clusters = {}
    for cluster in vmware_cluster_data['Results']:
        clusters[cluster['Name']] = cluster['Moid']
        print(cluster['Name'])

    cluster_data = {}
    while True:
        print("")
        cluster_name = input("Enter VMware Cluster Name from above list: ")
        if cluster_name in clusters:
            cluster_data["cluster_name"] = cluster_name
            cluster_data["cluster_moid"] = clusters[cluster_name]
            break
        print("Enter a valid cluster name from above list")
    return cluster_data


def get_datastore(api_virt, cluster_moid):
    """
    Function to get Datastore Name
    """
    datastore_data = (json.loads(api_virt.get_virtualization_vmware_datastore_list(
        _preload_content=False,
        inlinecount='allpages',
        filter=f"Cluster.Moid eq '{cluster_moid}'",
        expand='RegisteredDevice($select=Moid)',
        select='Name,Moid,RegisteredDevice').data))['Results']

    datastore_name_list = [datastore['Name'] for datastore in datastore_data]
    print("")
    print("Available VMware Cluster Datastore Names: ")
    for datastore in datastore_name_list:
        print(datastore)

    datastore_info = {}
    while True:
        print("")
        datastore_name = input("Enter Datastore Name from above list: ")
        if datastore_name in datastore_name_list:
            datastore_info['datastore_name'] = datastore_name
            for datastore in datastore_data:
                if datastore['Name'] == datastore_name:
                    datastore_info['registered_device_moid'] = datastore['RegisteredDevice']['Moid']
            break
        print("Re-Enter Datastore Name from above list")
    return datastore_info


def get_dvs_net(api_virt, registered_device_moid):
    """
    Function to get VMware DVS Networks
    """
    vmware_dvs_list = api_virt.get_virtualization_vmware_distributed_network_list(
    filter=f"RegisteredDevice.Moid eq '{registered_device_moid}'"
    )['results']
    if vmware_dvs_list:
        dvs_nets = set()
        for net in vmware_dvs_list:
            dvs_nets.add(net['name'])

        print("")
        print("VMware Local Network list: ")
        for net in dvs_nets:
            print(net)

        while True:
            print("")
            dvs_net = input("Enter Network Name from above list: ")
            if dvs_net in dvs_nets:
                break
            print("Re-enter Network Name from above list")
        return dvs_net
    print("No DVS Networks")
    return ""


def get_local_net(api_virt, registered_device_moid):
    """
    Function to get VMware Local Network
    """
    vmware_network_list = api_virt.get_virtualization_vmware_network_list(
    filter=f"RegisteredDevice.Moid eq '{registered_device_moid}'"
    )['results']

    if vmware_network_list:
        local_nets = set()
        for net in vmware_network_list:
            local_nets.add(net['name'])

        print("")
        print("VMware Local Network list: ")
        for net in local_nets:
            print(net)

        while True:
            print("")
            local_net = input("Enter Network Name from above list: ")
            if local_net in local_nets:
                break
            print("Re-enter Network Name from above list")
        return local_net
    print("No Local Networks")
    return ""


def create_vm_infra_config(api_client, org_rel, var_data):
    """
    Function to create VM Infra Config Policy
    """
    api_virt = virtualization_api.VirtualizationApi(api_client)
    vmware_cluster_data = json.loads(
        api_virt.get_virtualization_vmware_cluster_list(_preload_content=False
    ).data)

    cluster_data = get_cluster_name(vmware_cluster_data)
    cluster_name = cluster_data['cluster_name']
    cluster_moid = cluster_data['cluster_moid']

    datastore_info = get_datastore(api_virt, cluster_moid)
    datastore_name = datastore_info['datastore_name']
    registered_device_moid = datastore_info['registered_device_moid']

    while True:
        print("Choose Local Network or DVS Network: ")
        net = input("Enter network type: (local|dvs) ")
        if net == 'local':
            local_net_name = get_local_net(api_virt, registered_device_moid)
            if local_net_name:
                break
        if net == 'dvs':
            dvs_net_name = get_dvs_net(api_virt, registered_device_moid)
            if dvs_net_name:
                break

    esxi_vm_infra_config = KubernetesEsxiVirtualMachineInfraConfig(
        class_id = "kubernetes.EsxiVirtualMachineInfraConfig",
        object_type = "kubernetes.EsxiVirtualMachineInfraConfig",
        cluster = cluster_name,
        datastore = datastore_name,
        resource_pool = var_data['esxi_vm_infra']['resource_pool'],
        passphrase = var_data['esxi_vm_infra']['passphrase'],
        interfaces = [local_net_name]
    )

    asset_device_reg_rel = AssetDeviceRegistrationRelationship(
        class_id="mo.MoRef",
        moid=registered_device_moid,
        object_type='asset.DeviceRegistration'
    )

    kubernetes_virtual_machine_infra_config_policy = KubernetesVirtualMachineInfraConfigPolicy(
        class_id = "kubernetes.VirtualMachineInfraConfigPolicy",
        object_type = "kubernetes.VirtualMachineInfraConfigPolicy",
        name = var_data['name'],
        description = var_data['description'],
        organization = org_rel,
        vm_config = esxi_vm_infra_config,
        target = asset_device_reg_rel
    )

    api_instance = iksApi.KubernetesApi(api_client)
    vm_infra_config = api_instance.create_kubernetes_virtual_machine_infra_config_policy(
        kubernetes_virtual_machine_infra_config_policy
    )
    vm_infra_config_moid = vm_infra_config['moid']
    return vm_infra_config_moid
