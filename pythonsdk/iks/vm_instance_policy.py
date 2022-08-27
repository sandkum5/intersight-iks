"""
    Module to create VM Instance Policy
"""
import intersight.api.kubernetes_api as iksApi
from intersight.model.kubernetes_virtual_machine_instance_type \
    import KubernetesVirtualMachineInstanceType
import logging

log = logging.getLogger(__name__)


def create_vm_instance(api_client, org_rel, var_data):
    """
    Function to create VM Instance Policy
    """
    kubernetes_virtual_machine_instance_type = KubernetesVirtualMachineInstanceType(
        name = var_data['name'],
        description = var_data['description'],
        organization = org_rel,
        cpu = var_data['vm_instance']['cpu'],
        disk_size = var_data['vm_instance']['disk_size'],
        memory = var_data['vm_instance']['memory']
    )

    api_instance = iksApi.KubernetesApi(api_client)
    vm_instance = api_instance.create_kubernetes_virtual_machine_instance_type(
        kubernetes_virtual_machine_instance_type
    )
    vm_instance_moid = vm_instance['moid']
    return vm_instance_moid
