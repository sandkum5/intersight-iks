"""
    Module to create Worker VM Infra Provider
"""
import intersight.api.kubernetes_api as iksApi
from intersight.model.kubernetes_virtual_machine_infrastructure_provider \
    import KubernetesVirtualMachineInfrastructureProvider
from intersight.model.kubernetes_virtual_machine_instance_type_relationship \
    import KubernetesVirtualMachineInstanceTypeRelationship
from intersight.model.kubernetes_virtual_machine_infra_config_policy_relationship \
    import KubernetesVirtualMachineInfraConfigPolicyRelationship
from intersight.model.kubernetes_node_group_profile_relationship \
    import KubernetesNodeGroupProfileRelationship
import logging

log = logging.getLogger(__name__)


def create_worker_vm_infra_provider(api_client, org_rel, var_data, moid_data):
    """
    Function to create Worker VM Infra Provider
    """
    kube_vm_instance_type_rel = KubernetesVirtualMachineInstanceTypeRelationship(
        class_id = "mo.MoRef",
        object_type = "kubernetes.VirtualMachineInstanceType",
        moid = moid_data['vm_instance_moid']
        # selector = "$filter=Name eq 'pysdk_demo'"
    )

    kube_vm_infra_config_policy_rel = KubernetesVirtualMachineInfraConfigPolicyRelationship(
        class_id = "mo.MoRef",
        object_type = "kubernetes.VirtualMachineInfraConfigPolicy",
        moid = moid_data['vm_infra_config_moid']
        # selector = "$filter=Name eq 'pysdk_demo'"
    )

    worker_node_group_profile_rel = KubernetesNodeGroupProfileRelationship(
        class_id = "mo.MoRef",
        object_type = "kubernetes.NodeGroupProfile",
        moid = moid_data['worker_node_group_moid']
        # selector = "$filter=Name eq 'pysdk_demo'"
    )

    kubernetes_vm_infra_provider = KubernetesVirtualMachineInfrastructureProvider(
        name = var_data['worker_vm_infra_provider']['name'],
        description = var_data['description'],
        instance_type = kube_vm_instance_type_rel,
        infra_config_policy = kube_vm_infra_config_policy_rel,
        node_group = worker_node_group_profile_rel
    )

    api_instance = iksApi.KubernetesApi(api_client)
    worker_vm_infra_provider = api_instance.create_kubernetes_virtual_machine_infrastructure_provider(
        kubernetes_vm_infra_provider
    )
    worker_vm_infra_provider_moid = worker_vm_infra_provider['moid']
    return worker_vm_infra_provider_moid
